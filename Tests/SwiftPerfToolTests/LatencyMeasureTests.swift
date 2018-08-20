import XCTest
import SwiftPerfTool

final class LatencyMeasureTests: XCTestCase {
    
    func testLatencySingleRun() {
        let cfg = SFTConfig(iterations: 1, trials: [ { Thread.sleep(forTimeInterval: 0.1) } ])
        let res = runMeasure(with: cfg)
        
        XCTAssertTrue(res.total ==~ res.mean)
        XCTAssertTrue(res.sd ==~ 0)
        
        XCTAssertTrue(res.total.isApproximateEqual(to: 0.1, epsilon: 0.01))
        XCTAssertTrue(50...52 ~= res.scores / 1000)
    }
    
    func testLatencyMultipleRun() {
        let cfg = SFTConfig(iterations: 3, trials: [ { Thread.sleep(forTimeInterval: 0.1) } ])
        
        let res = runMeasure(with: cfg)
        
        XCTAssertTrue(res.total ==~ 3*res.mean)
        XCTAssertTrue(res.sd.isApproximateEqual(to: 0, epsilon: 0.01))
        
        XCTAssertTrue(res.total.isApproximateEqual(to: 0.3, epsilon: 0.01))
        XCTAssertTrue(50...52 ~= res.scores / 1000)
    }
    
    func testLatencyMultipleRun2() {
        let cfg = SFTConfig(iterations: 1, trials: [ { Thread.sleep(forTimeInterval: 0.1) },
                                                     { Thread.sleep(forTimeInterval: 0.1) },
                                                     { Thread.sleep(forTimeInterval: 0.1) } ])
        
        let res = runMeasure(with: cfg)
        
        XCTAssertTrue(res.total ==~ 3*res.mean)
        XCTAssertTrue(res.sd.isApproximateEqual(to: 0, epsilon: 0.01))
        
        XCTAssertTrue(res.total.isApproximateEqual(to: 0.3, epsilon: 0.01))
        XCTAssertTrue(50...52 ~= res.scores / 1000)
    }
    
    func testScores() {
        let r1 = runMeasure(with: SFTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.1) } ]))
        let r2 = runMeasure(with: SFTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.05) } ]))
        let r3 = runMeasure(with: SFTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.01) } ]))
        let r4 = runMeasure(with: SFTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.001) }]))
        let r5 = runMeasure(with: SFTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.0001) }]))
        
        XCTAssertGreaterThan(r1.scores, r2.scores)
        XCTAssertGreaterThan(r2.scores, r3.scores)
        XCTAssertGreaterThan(r4.scores, r5.scores)
    }

    static var allTests = [
        ("testLatencySingleRun", testLatencySingleRun),
        ("testLatencyMultipleRun", testLatencyMultipleRun),
        ("testLatencyMultipleRun2", testLatencyMultipleRun2),
        ("testScores", testScores),
    ]
}
