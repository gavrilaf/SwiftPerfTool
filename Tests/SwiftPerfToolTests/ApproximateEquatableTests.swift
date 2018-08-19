import XCTest
import SwiftPerfTool

class ApproximateEquatableTests: XCTestCase {
    func testEqual() {
        XCTAssertEqual(10.00000001 ==~ 10.00000002, true)
        XCTAssertEqual(10.00000001 ==~ 10, true)
        XCTAssertEqual(10000000 ==~ 10000000, true)
        
        XCTAssertEqual(10.000001 ==~ 10.00000, false)
        XCTAssertEqual(10000000 ==~ 20000000, false)
    }
}
