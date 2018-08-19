import Foundation

infix operator ==~ : ComparisonPrecedence
infix operator !==~ : ComparisonPrecedence

public protocol ApproximateEquatable: Strideable {
    static var EPSILON: Self { get }
    
    func isApproximateEqual(to value: Self, epsilon: Self) -> Bool
}

extension ApproximateEquatable {
    public static func ==~(lhs: Self, rhs: Self) -> Bool {
        return lhs.isApproximateEqual(to: rhs, epsilon: EPSILON)
    }
    
    public static func !==~(lhs: Self, rhs: Self) -> Bool {
        return !(lhs ==~ rhs)
    }
}

extension Double: ApproximateEquatable {
    
    public static let EPSILON = 0.0000001
    
    public func isApproximateEqual(to value: Double, epsilon: Double = Double.EPSILON) -> Bool {
        return abs(self - value) <= epsilon
    }
}
