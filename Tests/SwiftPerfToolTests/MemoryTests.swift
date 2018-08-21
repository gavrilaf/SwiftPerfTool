import XCTest
import SwiftPerfTool

class MemoryTests: XCTestCase {
    func testMemoryReport() {
        let before = try! reportMemory()
        let dummy = Array<UInt64>(repeating: 0, count: 1000000)
        let after = try! reportMemory()
        
        let used = after.unsafeSubtracting(before).unsafeDivided(by: UInt64(MemoryLayout<UInt64>.size))
        
        XCTAssertGreaterThanOrEqual(used, UInt64(dummy.count))
    }
}
