import Foundation

// MARK: -
public struct SFTConfig {
    public let iteractions: Int
    public let batchSize: Int
    
    public init(iteractions: Int, batchSize: Int) {
        self.iteractions = iteractions
        self.batchSize = batchSize
    }
}

// MARK: -
public struct SFTResult: Equatable {
    public let total: Double
    public let mean: Double
    public let sd: Double
    public let scores: Int
    
    public init(total: UInt64, mean: Double, sd: Double, scores: Double) {
        self.total = Double(total) / 1_000_000_000
        self.mean = mean / 1_000_000_000
        self.sd = sd / 1_000_000_000
        self.scores = lround(scores / 1_000)
    }
}

extension SFTResult: CustomStringConvertible {
    public var description: String {
        return "total = \(total), mean = \(mean), sd = \(sd), SCORES = \(scores)"
    }
}

// MARK: -
public func runMeasure(with config: SFTConfig, _ block: () -> Void) -> SFTResult {
    var latencies = Array<UInt64>()

    for _ in 0..<config.iteractions {
        let start = DispatchTime.now()
        block()
        let end = DispatchTime.now()
        latencies.append(end.uptimeNanoseconds - start.uptimeNanoseconds)
    }
    
    let total = latencies.reduce(0) { (res, t) -> UInt64 in
        return res + t
    }
    
    let mean = Double(total) / Double(config.iteractions*config.batchSize)
    let sqtotal = latencies.reduce(0.0) { (res, t) -> Double in
        let centered = Double(t) - mean
        return res + (centered * centered) / Double(latencies.count)
    }
    
    let sd = sqrt(sqtotal)
    let score = 0.5 * (mean + sd)

    return SFTResult(total: total, mean: mean, sd: sd, scores: score)
}
