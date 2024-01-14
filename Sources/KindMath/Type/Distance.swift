//
//  KindKit
//

import Foundation

public struct Distance : Hashable {
    
    public var value: Double
    
    public init< Value : BinaryInteger >(_ value: Value) {
        self.value = Double(value)
    }
    
    public init< Value : BinaryFloatingPoint >(_ value: Value) {
        self.value = Double(value)
    }
    
}

public extension Distance {
    
    @inlinable
    static var zero: Self {
        return .init(0)
    }
    
}

public extension Distance {
    
    @inlinable
    var squared: Distance.Squared {
        return .init(self.value * self.value)
    }
    
    @inlinable
    var abs: Self {
        return .init(self.value.abs)
    }
    
    @inlinable
    var roundUp: Self {
        return .init(self.value.roundUp)
    }
    
    @inlinable
    var roundDown: Self {
        return .init(self.value.roundDown)
    }
    
    @inlinable
    var roundNearest: Self {
        return .init(self.value.roundNearest)
    }
    
}

public extension Distance {
    
    @inlinable
    static prefix func + (arg: Self) -> Self {
        return .init(+arg.value)
    }
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(-arg.value)
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func + (lhs: Self, rhs: Percent) -> Self {
        return .init(lhs.value + rhs.value)
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func += (lhs: inout Self, rhs: Percent) {
        lhs = lhs + rhs
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func - (lhs: Self, rhs: Percent) -> Self {
        return .init(lhs.value - rhs.value)
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Percent) {
        lhs = lhs - rhs
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func * (lhs: Self, rhs: Percent) -> Self {
        return .init(lhs.value * rhs.value)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        let point = Point(x: lhs.value, y: 0) * rhs
        return point.length
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Percent) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs * rhs
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func / (lhs: Self, rhs: Percent) -> Self {
        return .init(lhs.value / rhs.value)
    }
    
}

public extension Distance {
    
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
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Percent) {
        lhs = lhs / rhs
    }
    
}

extension Distance : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
}

extension Distance : IMapable {
}

extension Distance : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.value ~~ rhs.value
    }
    
}

extension Distance : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(self.value.lerp(to.value, progress: progress))
    }
    
}
