import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ServiceDTOTests.allTests),
        testCase(ServiceMockDataSourceTests.allTests),
        testCase(ServiceRepositoryTests.allTests),
    ]
}
#endif
