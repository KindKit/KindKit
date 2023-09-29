//
//  KindKit
//

import Foundation

public extension Distance {
    
    struct Squared : Hashable {
        
        public var value: Double
        
        public init(_ value: Double) {
            self.value = value
        }
        
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static var zero: Self {
        return .init(0)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    var normal: Distance {
        return .init(self.value.sqrt)
    }
    
    @inlinable
    var abs: Self {
        return .init(self.value.abs)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static prefix func + (arg: Self) -> Self {
        return .init(+arg.value)
    }
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(-arg.value)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value + rhs.value)
    }
    
    @inlinable
    static func + < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value + Double(rhs))
    }
    
    @inlinable
    static func + < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) + rhs.value)
    }
    
    @inlinable
    static func + < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value + Double(rhs))
    }
    
    @inlinable
    static func + < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) + rhs.value)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += < Value : BinaryInteger >(lhs: inout Self, rhs: Value) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += < Value : BinaryFloatingPoint >(lhs: inout Self, rhs: Value) {
        lhs = lhs + rhs
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value - rhs.value)
    }
    
    @inlinable
    static func - < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value - Double(rhs))
    }
    
    @inlinable
    static func - < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) - rhs.value)
    }
    
    @inlinable
    static func - < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value - Double(rhs))
    }
    
    @inlinable
    static func - < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) - rhs.value)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= < Value : BinaryInteger >(lhs: inout Self, rhs: Value) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= < Value : BinaryFloatingPoint >(lhs: inout Self, rhs: Value) {
        lhs = lhs - rhs
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value * rhs.value)
    }
    
    @inlinable
    static func * < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value * Double(rhs))
    }
    
    @inlinable
    static func * < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) * rhs.value)
    }
    
    @inlinable
    static func * < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value * Double(rhs))
    }
    
    @inlinable
    static func * < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) * rhs.value)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= < Value : BinaryInteger >(lhs: inout Self, rhs: Value) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= < Value : BinaryFloatingPoint >(lhs: inout Self, rhs: Value) {
        lhs = lhs * rhs
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value / rhs.value)
    }
    
    @inlinable
    static func / < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value / Double(rhs))
    }
    
    @inlinable
    static func / < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) / rhs.value)
    }
    
    @inlinable
    static func / < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(lhs.value / Double(rhs))
    }
    
    @inlinable
    static func / < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(Double(lhs) / rhs.value)
    }
    
}

public extension Distance.Squared {
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= < Value : BinaryInteger >(lhs: inout Self, rhs: Value) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= < Value : BinaryFloatingPoint >(lhs: inout Self, rhs: Value) {
        lhs = lhs / rhs
    }
    
}

extension Distance.Squared : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
}

extension Distance.Squared : IMapable {
}

extension Distance.Squared : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.value ~~ rhs.value
    }
    
}
