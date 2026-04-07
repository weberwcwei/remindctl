import Testing

@testable import RemindCore

@MainActor
struct ErrorsTests {
  @Test("Error descriptions")
  func descriptions() {
    #expect(RemindCoreError.accessDenied.localizedDescription.contains("Reminders"))
    #expect(RemindCoreError.writeOnlyAccess.localizedDescription.contains("write-only"))
    #expect(RemindCoreError.listNotFound("Work").localizedDescription.contains("Work"))
    #expect(RemindCoreError.reminderNotFound("abc").localizedDescription.contains("abc"))
    #expect(RemindCoreError.ambiguousIdentifier("a", matches: ["ABCD1234 First", "ABCE5678 Second"]).localizedDescription.contains("disambiguate"))
    #expect(RemindCoreError.invalidIdentifier("x").localizedDescription.contains("Invalid identifier"))
    #expect(RemindCoreError.invalidDate("bad").localizedDescription.contains("Invalid date"))
    #expect(RemindCoreError.unsupported("nope").localizedDescription.contains("nope"))
    #expect(RemindCoreError.operationFailed("fail").localizedDescription.contains("fail"))
  }
}
