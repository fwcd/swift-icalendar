import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ICalendarTests.allTests),
        testCase(StringUtilitiesTests.allTests)
    ]
}
#endif