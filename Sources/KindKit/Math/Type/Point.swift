//
//  KindKit
//

import Foundation

public struct Point : Hashable {
    
    public var x: Double
    public var y: Double
    
    public init(
        x: Double,
        y: Double
    ) {
        self.x = x
        self.y = y
    }
    
}

public extension Point {
    
    @inlinable
    static var infinity: Self {
        return Point(x: .infinity, y: .infinity)
    }
    
    @inlinable
    static var zero: Self {
        return Point(x: 0, y: 0)
    }
    
    @inlinable
    static var one: Self {
        return Point(x: 1, y: 1)
    }
    
}

public extension Point {
    
    @inlinable
    var isInfinite: Bool {
        return self.x.isInfinite == true && self.y.isInfinite == true
    }
    
    @inlinable
    var isZero: Bool {
        return self.x ~~ 0 && self.y ~~ 0
    }
    
    @inlinable
    var isOne: Bool {
        return self.x ~~ 1 && self.y ~~ 1
    }
    
    @inlinable
    var invert: Self {
        return -self
    }
    
    @inlinable
    var wrap: Self {
        return Point(x: self.y, y: self.x)
    }
    
    @inlinable
    var length: Distance {
        return self.squaredLength.normal
    }
    
    @inlinable
    var squaredLength: Distance.Squared {
        return .init(self.dot(self))
    }
    
    @inlinable
    var perpendicular: Self {
        return Point(x: self.y, y: -self.x)
    }
    
    @inlinable
    var normalized: (point: Self, length: Distance.Squared) {
        let length = self.squaredLength
        if length.value > 0 {
            return (point: self / length.normal, length: length)
        }
        return (point: .zero, length: length)
    }
    
    @inlinable
    var angle: Angle {
        return Angle(radians: self.y.atan2(self.x))
    }
    
}

public extension Point {
    
    @inlinable
    func dot(_ other: Self) -> Double {
        return self.x * other.x + self.y * other.y
    }
    
    @inlinable
    func cross(_ other: Self) -> Double {
        return self.x * other.y - self.y * other.x
    }
    
    @inlinable
    func distance(_ other: Self) -> Distance {
        return self.squaredDistance(other).normal
    }
    
    @inlinable
    func squaredDistance(_ other: Self) -> Distance.Squared {
        return (self - other).squaredLength
    }
    
    @inlinable
    func max(_ arg: Self) -> Self {
        return Point(x: Swift.max(self.x, arg.x), y: Swift.max(self.y, arg.y))
    }
    
    @inlinable
    func min(_ arg: Self) -> Self {
        return Point(x: Swift.min(self.x, arg.x), y: Swift.min(self.y, arg.y))
    }
    
    @inlinable
    func angle(_ point1: Self, _ point2: Self) -> Angle {
        let d1 = point1 - self
        let d2 = point2 - self
        return Angle(radians: d1.cross(d2).atan2(d1.dot(d2)))
    }
    
}

public extension Point {
    
    @inlinable
    static prefix func + (arg: Self) -> Self {
        return Point(x: +arg.x, y: +arg.y)
    }
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Point(x: -arg.x, y: -arg.y)
    }
    
}

public extension Point {
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    @inlinable
    static func + < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x + Double(rhs), y: lhs.y + Double(rhs))
    }
    
    @inlinable
    static func + < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) + rhs.x, y: Double(lhs) + rhs.y)
    }
    
    @inlinable
    static func + < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x + Double(rhs), y: lhs.y + Double(rhs))
    }
    
    @inlinable
    static func + < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) + rhs.x, y: Double(lhs) + rhs.y)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Distance) -> Self {
        return .init(x: lhs.x + rhs.value, y: lhs.y + rhs.value)
    }
    
    @inlinable
    static func + (lhs: Distance, rhs: Self) -> Self {
        return .init(x: lhs.value + rhs.x, y: lhs.value + rhs.y)
    }
    
}

public extension Point {
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Distance) {
        lhs = lhs + rhs
    }
    
}

public extension Point {
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @inlinable
    static func - < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x - Double(rhs), y: lhs.y - Double(rhs))
    }
    
    @inlinable
    static func - < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) - rhs.x, y: Double(lhs) - rhs.y)
    }
    
    @inlinable
    static func - < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x - Double(rhs), y: lhs.y - Double(rhs))
    }
    
    @inlinable
    static func - < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) - rhs.x, y: Double(lhs) - rhs.y)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Distance) -> Self {
        return Point(x: lhs.x - rhs.value, y: lhs.y - rhs.value)
    }
    
    @inlinable
    static func - (lhs: Distance, rhs: Self) -> Self {
        return Point(x: lhs.value - rhs.x, y: lhs.value - rhs.y)
    }
    
}

public extension Point {
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Distance) {
        lhs = lhs - rhs
    }
    
}

public extension Point {
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @inlinable
    static func * < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x * Double(rhs), y: lhs.y * Double(rhs))
    }
    
    @inlinable
    static func * < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) * rhs.x, y: Double(lhs) * rhs.y)
    }
    
    @inlinable
    static func * < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x * Double(rhs), y: lhs.y * Double(rhs))
    }
    
    @inlinable
    static func * < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) * rhs.x, y: Double(lhs) * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Distance) -> Self {
        return Point(x: lhs.x * rhs.value, y: lhs.y * rhs.value)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Percent) -> Self {
        return Point(x: lhs.x * rhs.value, y: lhs.y * rhs.value)
    }
    
    @inlinable
    static func * (lhs: Distance, rhs: Self) -> Self {
        return Point(x: lhs.value * rhs.x, y: lhs.value * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Percent, rhs: Self) -> Self {
        return Point(x: lhs.value * rhs.x, y: lhs.value * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return Point(
            x: lhs.x * rhs.m11 + lhs.y * rhs.m21 + rhs.m31,
            y: lhs.x * rhs.m12 + lhs.y * rhs.m22 + rhs.m32
        )
    }
    
}

public extension Point {
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Distance) {
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

public extension Point {
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @inlinable
    static func / < Value : BinaryInteger >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x / Double(rhs), y: lhs.y / Double(rhs))
    }
    
    @inlinable
    static func / < Value : BinaryInteger >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) / rhs.x, y: Double(lhs) / rhs.y)
    }
    
    @inlinable
    static func / < Value : BinaryFloatingPoint >(lhs: Self, rhs: Value) -> Self {
        return .init(x: lhs.x / Double(rhs), y: lhs.y / Double(rhs))
    }
    
    @inlinable
    static func / < Value : BinaryFloatingPoint >(lhs: Value, rhs: Self) -> Self {
        return .init(x: Double(lhs) / rhs.x, y: Double(lhs) / rhs.y)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Distance) -> Self {
        return Point(x: lhs.x / rhs.value, y: lhs.y / rhs.value)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Percent) -> Self {
        return Point(x: lhs.x / rhs.value, y: lhs.y / rhs.value)
    }
    
    @inlinable
    static func / (lhs: Distance, rhs: Self) -> Self {
        return Point(x: lhs.value / rhs.x, y: lhs.value / rhs.y)
    }
    
    @inlinable
    static func / (lhs: Percent, rhs: Self) -> Self {
        return Point(x: lhs.value / rhs.x, y: lhs.value / rhs.y)
    }
    
}

public extension Point {
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Distance) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Percent) {
        lhs = lhs / rhs
    }
    
}

extension Point : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.x ~~ rhs.x && lhs.y ~~ rhs.y
    }
    
}

extension Point : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
}

extension Point : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let x = self.x.lerp(to.x, progress: progress)
        let y = self.y.lerp(to.y, progress: progress)
        return Point(x: x, y: y)
    }
    
}
