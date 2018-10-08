import XCTest
import SwiftPerfTool

final class LatencyMeasureTests: XCTestCase {
    
    func testLatencySingleRun() {
        let cfg = SPTConfig(iterations: 1, trials: [ { Thread.sleep(forTimeInterval: 0.1) } ])
        let metrics = runMeasure(with: cfg)
        
        XCTAssertTrue(metrics.timeMean.isApproximateEqual(to: 0.1, epsilon: 0.01))
        XCTAssertTrue(metrics.timeSd ==~ 0)
        XCTAssertTrue(50...52 ~= metrics.timeScores / 1000)
    }
    
    func testLatencyMultipleRun() {
        let cfg = SPTConfig(iterations: 3, trials: [ { Thread.sleep(forTimeInterval: 0.1) } ])
        let metrics = runMeasure(with: cfg)
        
        XCTAssertTrue(metrics.timeMean.isApproximateEqual(to: 0.1, epsilon: 0.01))
        XCTAssertTrue(metrics.timeSd.isApproximateEqual(to: 0, epsilon: 0.01))
        XCTAssertTrue(50...52 ~= metrics.timeScores / 1000)
    }
    
    func testLatencyMultipleRun2() {
        let cfg = SPTConfig(iterations: 1, trials: [ { Thread.sleep(forTimeInterval: 0.1) },
                                                     { Thread.sleep(forTimeInterval: 0.1) },
                                                     { Thread.sleep(forTimeInterval: 0.1) } ])
        let metrics = runMeasure(with: cfg)
        
        XCTAssertTrue(metrics.timeMean.isApproximateEqual(to: 0.1, epsilon: 0.01))
        XCTAssertTrue(metrics.timeSd.isApproximateEqual(to: 0, epsilon: 0.01))
        XCTAssertTrue(50...52 ~= metrics.timeScores / 1000)
    }
    
    func testScoreTimeRelation() {
        let m1 = runMeasure(with: SPTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.1) } ]))
        let m2 = runMeasure(with: SPTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.05) } ]))
        let m3 = runMeasure(with: SPTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.01) } ]))
        let m4 = runMeasure(with: SPTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.001) }]))
        let m5 = runMeasure(with: SPTConfig(iterations: 5, trials: [ { Thread.sleep(forTimeInterval: 0.0001) }]))
        
        XCTAssertGreaterThan(m1.timeScores, m2.timeScores)
        XCTAssertGreaterThan(m2.timeScores, m3.timeScores)
        XCTAssertGreaterThan(m4.timeScores, m5.timeScores)
    }

    static var allTests = [
        ("testLatencySingleRun", testLatencySingleRun),
        ("testLatencyMultipleRun", testLatencyMultipleRun),
        ("testLatencyMultipleRun2", testLatencyMultipleRun2),
        ("testScoreTimeRelation", testScoreTimeRelation),
    ]
}
