//
//  KindKit
//

import Foundation

public struct Percent : Hashable {
    
    public var value: Double
    
    public init< Input : BinaryInteger >(_ value: Input) {
        self.value = Double(value)
    }
    
    public init< Input : BinaryFloatingPoint >(_ value: Input) {
        self.value = Double(value)
    }
    
    public init< Input : BinaryInteger >(_ current: Input, from: Input) {
        self.value = Double(current) / Double(from)
    }
    
    public init< Input : BinaryFloatingPoint >(_ current: Input, from: Input) {
        self.value = Double(current) / Double(from)
    }
    
    public init(_ current: Distance, from: Distance) {
        self.value = current.value / from.value
    }
    
    public init< Input : BinaryInteger >(_ current: Input, from: Distance) {
        self.value = Double(current) / from.value
    }
    
    public init< Input : BinaryInteger >(_ current: Distance, from: Input) {
        self.value = current.value / Double(from)
    }
    
    public init< Input : BinaryFloatingPoint >(_ current: Input, from: Distance) {
        self.value = Double(current) / from.value
    }
    
    public init< Input : BinaryFloatingPoint >(_ current: Distance, from: Input) {
        self.value = current.value / Double(from)
    }
    
}

public extension Percent {
    
    @inlinable
    static var zero: Self {
        return .init(0.0)
    }
    
    @inlinable
    static var half: Self {
        return .init(0.5)
    }
    
    @inlinable
    static var one: Self {
        return .init(1.0)
    }

}

public extension Percent {
    
    @inlinable
    var isZero: Bool {
        return self ~~ .zero
    }
    
    @inlinable
    var isHalf: Bool {
        return self ~~ .half
    }
    
    @inlinable
    var isOne: Bool {
        return self ~~ .one
    }
    
    @inlinable
    var invert: Self {
        return .one - self
    }
    
    @inlinable
    var normalized: Self {
        return .init(self.value.clamp(0, 1))
    }
    
}

public extension Percent {
    
    @inlinable
    func clamp(_ lower: Self, _ upper: Self) -> Self {
        return .init(self.value.clamp(lower.value, upper.value))
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(self.value.lerp(to.value, progress: progress))
    }
    
}

public extension Percent {
    
    @inlinable
    static prefix func + (arg: Self) -> Self {
        return .init(+arg.value)
    }
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(-arg.value)
    }
    
}

public extension Percent {
    
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

public extension Percent {
    
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

public extension Percent {
    
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

public extension Percent {
    
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

public extension Percent {
    
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

public extension Percent {
    
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

public extension Percent {
    
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

public extension Percent {
    
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

extension Percent : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.value ~~ rhs.value
    }
    
}

extension Percent : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
}
