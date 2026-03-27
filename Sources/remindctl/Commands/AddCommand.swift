import Commander
import Foundation
import RemindCore

enum AddCommand {
  static var spec: CommandSpec {
    CommandSpec(
      name: "add",
      abstract: "Add a reminder",
      discussion: "Provide a title as an argument or via --title.",
      signature: CommandSignatures.withRuntimeFlags(
        CommandSignature(
          arguments: [
            .make(label: "titleOrList", help: "Reminder title (or list name if second arg given)", isOptional: true),
            .make(label: "titleWhenList", help: "Reminder title when first arg is a list name", isOptional: true),
          ],
          options: [
            .make(label: "title", names: [.long("title")], help: "Reminder title", parsing: .singleValue),
            .make(label: "list", names: [.short("l"), .long("list")], help: "List name", parsing: .singleValue),
            .make(label: "due", names: [.short("d"), .long("due")], help: "Due date", parsing: .singleValue),
            .make(label: "notes", names: [.short("n"), .long("notes")], help: "Notes", parsing: .singleValue),
            .make(
              label: "priority",
              names: [.short("p"), .long("priority")],
              help: "none|low|medium|high",
              parsing: .singleValue
            ),
            .make(
              label: "repeat",
              names: [.short("r"), .long("repeat")],
              help: "daily|weekly|biweekly|monthly|yearly|every N days/weeks/months",
              parsing: .singleValue
            ),
          ]
        )
      ),
      usageExamples: [
        "remindctl add \"Buy milk\"",
        "remindctl add \"Personal\" \"Buy milk\"",
        "remindctl add --title \"Call mom\" --list Personal --due tomorrow",
        "remindctl add \"Review docs\" --priority high",
        "remindctl add \"Take vitamins\" --due tomorrow --repeat daily",
      ]
    ) { values, runtime in
      let titleOption = values.option("title")
      let firstArg = values.argument(0)
      let secondArg = values.argument(1)

      // Two positional args: first is list name, second is title
      // One positional arg: it's the title
      // --title flag: explicit title
      let positionalTitle: String?
      var positionalList: String? = nil

      if let secondArg {
        // remindctl add "ListName" "Title"
        positionalList = firstArg
        positionalTitle = secondArg
      } else {
        positionalTitle = firstArg
      }

      if titleOption != nil && positionalTitle != nil {
        throw RemindCoreError.operationFailed("Provide title either as argument or via --title")
      }

      let listOption = values.option("list")
      if listOption != nil && positionalList != nil {
        throw RemindCoreError.operationFailed("Provide list either as first positional argument or via --list")
      }

      var title = titleOption ?? positionalTitle
      if title == nil {
        if runtime.noInput || !Console.isTTY {
          throw RemindCoreError.operationFailed("Missing title. Provide it as an argument or via --title.")
        }
        title = Console.readLine(prompt: "Title:")?.trimmingCharacters(in: .whitespacesAndNewlines)
        if title?.isEmpty == true { title = nil }
      }

      guard let title else {
        throw RemindCoreError.operationFailed("Missing title.")
      }

      let listName = listOption ?? positionalList
      let notes = values.option("notes")
      let dueValue = values.option("due")
      let priorityValue = values.option("priority")

      let dueDate = try dueValue.map(CommandHelpers.parseDueDate)
      let priority = try priorityValue.map(CommandHelpers.parsePriority) ?? .none
      let repeatValue = values.option("repeat")
      let recurrenceRule = try repeatValue.map(CommandHelpers.parseRecurrence)

      let store = RemindersStore()
      try await store.requestAccess()

      let targetList: String?
      if let listName {
        targetList = listName
      } else {
        targetList = await store.defaultListName()
      }
      guard let targetList else {
        throw RemindCoreError.operationFailed("No default list found. Specify --list.")
      }

      let draft = ReminderDraft(
        title: title, notes: notes, dueDate: dueDate,
        priority: priority, recurrenceRule: recurrenceRule
      )
      let reminder = try await store.createReminder(draft, listName: targetList)
      OutputRenderer.printReminder(reminder, format: runtime.outputFormat)
    }
  }
}
