import Foundation
import RemindCore

enum CommandHelpers {
  static func parsePriority(_ value: String) throws -> ReminderPriority {
    switch value.lowercased() {
    case "none":
      return .none
    case "low":
      return .low
    case "medium", "med":
      return .medium
    case "high":
      return .high
    default:
      throw RemindCoreError.operationFailed("Invalid priority: \"\(value)\" (use none|low|medium|high)")
    }
  }

  static func parseDueDate(_ value: String) throws -> Date {
    guard let date = DateParsing.parseUserDate(value) else {
      throw RemindCoreError.invalidDate(value)
    }
    return date
  }

  static func parseRecurrence(_ value: String) throws -> RecurrenceRule {
    let lower = value.lowercased().trimmingCharacters(in: .whitespaces)
    switch lower {
    case "daily":
      return RecurrenceRule(frequency: .daily, interval: 1)
    case "weekly":
      return RecurrenceRule(frequency: .weekly, interval: 1)
    case "biweekly":
      return RecurrenceRule(frequency: .weekly, interval: 2)
    case "monthly":
      return RecurrenceRule(frequency: .monthly, interval: 1)
    case "yearly":
      return RecurrenceRule(frequency: .yearly, interval: 1)
    default:
      // Parse "every N days/weeks/months/years"
      let pattern = #/^every\s+(\d+)\s+(days?|weeks?|months?|years?)$/#
      if let match = lower.firstMatch(of: pattern) {
        guard let n = Int(match.1), n > 0 else {
          throw RemindCoreError.operationFailed("Invalid repeat interval: \"\(value)\"")
        }
        let unit = String(match.2)
        let freq: RecurrenceFrequency
        if unit.hasPrefix("day") { freq = .daily }
        else if unit.hasPrefix("week") { freq = .weekly }
        else if unit.hasPrefix("month") { freq = .monthly }
        else { freq = .yearly }
        return RecurrenceRule(frequency: freq, interval: n)
      }
      throw RemindCoreError.operationFailed(
        "Invalid repeat value: \"\(value)\" (use daily|weekly|biweekly|monthly|yearly or \"every N days/weeks/months/years\")"
      )
    }
  }
}
