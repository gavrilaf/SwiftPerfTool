import Foundation

// MARK: -
public struct SFTMetrics: Equatable {
    
    public struct Time: Equatable {
        public let mean: Double
        public let sd: Double
        public let scores: Double
        
        public init(mean: Double, sd: Double, scores: Double) {
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
    
    public let time: Time
    public let memoryUsage: UInt64?
    
    public init(latencies: Array<UInt64>, memoryUsage: UInt64?) {
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
        return (memoryUsage ?? 0) / 1024
    }
}

extension SFTMetrics: CustomStringConvertible {
    public var description: String {
        return "Time scores: \(timeScores), mean: \(timeMean), sd: \(timeSd). Memory usage: \(memoryUsage != nil ? String(memory) : "not defined")"
    }
}

// MARK :-
func calcMemoryUsage(before: UInt64?, after: UInt64?) -> UInt64? {
    guard let before = before, let after = after else { return nil }
    let r = after.subtractingReportingOverflow(before)
    return r.overflow ? 0 : r.partialValue
}
