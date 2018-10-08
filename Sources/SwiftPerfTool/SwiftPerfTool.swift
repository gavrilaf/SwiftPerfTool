import Foundation

// MARK: -
public struct SPTConfig {
    public let iterations: Int
    public let trials: [() -> Void]
    
    public init(iterations: Int, trials: [() -> Void]) {
        self.iterations = iterations
        self.trials = trials
    }
}


// MARK: -
public func runMeasure(with config: SPTConfig) -> SPTMetrics {
    var latencies = Array<UInt64>(repeating: 0, count: config.iterations * config.trials.count)

    let memoryBefore = try? reportMemory()
    
    for iteration in 0..<config.iterations {
        for (trialIndx, block) in config.trials.enumerated() {
            let start = DispatchTime.now()
            block()
            let end = DispatchTime.now()
            latencies[iteration + trialIndx] = end.uptimeNanoseconds - start.uptimeNanoseconds
        }
    }
    
    let memoryAfter = try? reportMemory()
    
    return SPTMetrics(latencies: latencies, memoryUsage: calcMemoryUsage(before: memoryBefore, after: memoryAfter))
}
