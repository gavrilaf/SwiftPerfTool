import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ApproximateEquatableTests.allTests),
        testCase(LatencyMeasureTests.allTests),
    ]
}
#endif
