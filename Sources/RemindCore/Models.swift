import Foundation

public enum ReminderPriority: String, Codable, CaseIterable, Sendable {
  case none
  case low
  case medium
  case high

  public init(eventKitValue: Int) {
    switch eventKitValue {
    case 1...4:
      self = .high
    case 5:
      self = .medium
    case 6...9:
      self = .low
    default:
      self = .none
    }
  }

  public var eventKitValue: Int {
    switch self {
    case .none:
      return 0
    case .high:
      return 1
    case .medium:
      return 5
    case .low:
      return 9
    }
  }
}

public enum RecurrenceFrequency: String, Codable, Sendable, CaseIterable {
  case daily
  case weekly
  case monthly
  case yearly
}

public struct RecurrenceRule: Codable, Sendable, Equatable {
  public let frequency: RecurrenceFrequency
  public let interval: Int

  public init(frequency: RecurrenceFrequency, interval: Int) {
    self.frequency = frequency
    self.interval = interval
  }

  public var displayString: String {
    if interval == 1 {
      return frequency.rawValue
    }
    let unit: String
    switch frequency {
    case .daily: unit = interval == 1 ? "day" : "days"
    case .weekly: unit = interval == 1 ? "week" : "weeks"
    case .monthly: unit = interval == 1 ? "month" : "months"
    case .yearly: unit = interval == 1 ? "year" : "years"
    }
    return "every \(interval) \(unit)"
  }
}

public struct ReminderList: Identifiable, Codable, Sendable, Equatable {
  public let id: String
  public let title: String

  public init(id: String, title: String) {
    self.id = id
    self.title = title
  }
}

public struct ReminderItem: Identifiable, Codable, Sendable, Equatable {
  public let id: String
  public let title: String
  public let notes: String?
  public let isCompleted: Bool
  public let completionDate: Date?
  public let priority: ReminderPriority
  public let dueDate: Date?
  public let recurrenceRule: RecurrenceRule?
  public let listID: String
  public let listName: String

  public init(
    id: String,
    title: String,
    notes: String?,
    isCompleted: Bool,
    completionDate: Date?,
    priority: ReminderPriority,
    dueDate: Date?,
    recurrenceRule: RecurrenceRule? = nil,
    listID: String,
    listName: String
  ) {
    self.id = id
    self.title = title
    self.notes = notes
    self.isCompleted = isCompleted
    self.completionDate = completionDate
    self.priority = priority
    self.dueDate = dueDate
    self.recurrenceRule = recurrenceRule
    self.listID = listID
    self.listName = listName
  }
}

public struct ReminderDraft: Sendable {
  public let title: String
  public let notes: String?
  public let dueDate: Date?
  public let priority: ReminderPriority
  public let recurrenceRule: RecurrenceRule?

  public init(
    title: String,
    notes: String?,
    dueDate: Date?,
    priority: ReminderPriority,
    recurrenceRule: RecurrenceRule? = nil
  ) {
    self.title = title
    self.notes = notes
    self.dueDate = dueDate
    self.priority = priority
    self.recurrenceRule = recurrenceRule
  }
}

public struct ReminderUpdate: Sendable {
  public let title: String?
  public let notes: String?
  public let dueDate: Date??
  public let priority: ReminderPriority?
  public let listName: String?
  public let isCompleted: Bool?
  public let recurrenceRule: RecurrenceRule??

  public init(
    title: String? = nil,
    notes: String? = nil,
    dueDate: Date?? = nil,
    priority: ReminderPriority? = nil,
    listName: String? = nil,
    isCompleted: Bool? = nil,
    recurrenceRule: RecurrenceRule?? = nil
  ) {
    self.title = title
    self.notes = notes
    self.dueDate = dueDate
    self.priority = priority
    self.listName = listName
    self.isCompleted = isCompleted
    self.recurrenceRule = recurrenceRule
  }
}
