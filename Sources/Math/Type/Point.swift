//
//  KindKitMath
//

import Foundation

public typealias PointFloat = Point< Float >
public typealias PointDouble = Point< Double >

public struct Point< ValueType: IScalar & Hashable > : Hashable {
    
    public var x: ValueType
    public var y: ValueType
    
    @inlinable
    public init(
        x: ValueType,
        y: ValueType
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
    var length: Distance< ValueType > {
        return Distance(squared: self.dot(self))
    }
    
    @inlinable
    var perpendicular: Self {
        return Point(x: self.y, y: -self.x)
    }
    
    @inlinable
    var normalized: (point: Self, length: Distance< ValueType >) {
        let length = self.length
        if length.squared > 0 {
            return (point: self / length.real, length: length)
        }
        return (point: .zero, length: length)
    }
    
    @inlinable
    var angle: Angle< ValueType > {
        return Angle(radians: self.y.atan2(self.x))
    }
    
}

public extension Point {
    
    @inlinable
    func dot(_ other: Self) -> ValueType {
        return self.x * other.x + self.y * other.y
    }
    
    @inlinable
    func cross(_ other: Self) -> ValueType {
        return self.x * other.y - self.y * other.x
    }
    
    @inlinable
    func distance(_ other: Self) -> Distance< ValueType > {
        return (self - other).length
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
    func angle(_ point1: Self, _ point2: Self) -> Angle< ValueType > {
        let d1 = point1 - self
        let d2 = point2 - self
        return Angle(radians: d1.cross(d2).atan2(d1.dot(d2)))
    }
    
    @inlinable
    func lerp(_ to: Self, progress: ValueType) -> Self {
        let x = self.x.lerp(to.x, progress: progress)
        let y = self.y.lerp(to.y, progress: progress)
        return Point(x: x, y: y)
    }
    
}

public extension Point {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return Point(x: -arg.x, y: -arg.y)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: ValueType) -> Self {
        return Point(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    
    @inlinable
    static func + (lhs: ValueType, rhs: Self) -> Self {
        return Point(x: lhs + rhs.x, y: lhs + rhs.y)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: ValueType) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: ValueType) -> Self {
        return Point(x: lhs.x - rhs, y: lhs.y - rhs)
    }
    
    @inlinable
    static func - (lhs: ValueType, rhs: Self) -> Self {
        return Point(x: lhs - rhs.x, y: lhs - rhs.y)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: ValueType) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: ValueType) -> Self {
        return Point(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    @inlinable
    static func * (lhs: ValueType, rhs: Self) -> Self {
        return Point(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3< ValueType >) -> Self {
        return Point(
            x: lhs.x * rhs.m11 + lhs.y * rhs.m21 + rhs.m31,
            y: lhs.x * rhs.m12 + lhs.y * rhs.m22 + rhs.m32
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: ValueType) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3< ValueType >) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: ValueType) -> Self {
        return Point(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    @inlinable
    static func / (lhs: ValueType, rhs: Self) -> Self {
        return Point(x: lhs / rhs.x, y: lhs / rhs.y)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: ValueType) {
        lhs = lhs / rhs
    }
    
}

extension Point : INearEqutable {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        return lhs.x ~~ rhs.x && lhs.y ~~ rhs.y
    }
    
}

extension Point : Comparable where ValueType: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
}
