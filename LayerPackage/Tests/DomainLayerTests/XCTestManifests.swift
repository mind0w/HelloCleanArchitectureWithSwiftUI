import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ServiceModelTests.allTests),
        testCase(FetchServiceTests.allTests),
        testCase(InsertServiceTests.allTests),
    ]
}
#endif
