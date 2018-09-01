import Foundation

// MARK: -
public struct SFTMetrics: Equatable {
    
    struct Time: Equatable {
        let mean: Double
        let sd: Double
        let scores: Double
        
        init(mean: Double, sd: Double, scores: Double) {
            self.mean = mean
            self.sd = sd
            self.scores = scores
        }
        
        public init(from latencies: Array<UInt64>) {
            let total = latencies.reduce(0) { (res, t) -> UInt64 in
                return res + t
            }
            
            let mean = Double(total) / Double(latencies.count)
            let sqtotal = latencies.reduce(0.0) { (res, t) -> Double in
                let centered = Double(t) - mean
                return res + (centered * centered) / Double(latencies.count)
            }
            
            self.mean = mean
            self.sd = sqrt(sqtotal)
            self.scores = 0.5 * (mean + sd)
        }
    }
    
    let time: Time
    let memoryUsage: UInt64
    
    public init(latencies: Array<UInt64>, memoryUsage: UInt64) {
        self.time = Time(from: latencies)
        self.memoryUsage = memoryUsage
    }
    
    public var timeMean: Double {
        return Double(time.mean) / 1_000_000_000
    }
    
    public var timeSd: Double {
        return Double(time.sd) / 1_000_000_000
    }
    
    public var timeScores: Int {
        return lround(time.scores / 1_000)
    }
    
    public var memory: UInt64 {
        return memoryUsage / 1024
    }
}
