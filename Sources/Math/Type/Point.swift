//
//  KindKitMath
//

import Foundation

public typealias PointFloat = Point< Float >
public typealias PointDouble = Point< Double >

public struct Point< ValueType: BinaryFloatingPoint > : Hashable {
    
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
    
}

public extension Point {
    
    @inlinable
    var isInfinite: Bool {
        return self.x.isInfinite == true && self.y.isInfinite == true
    }
    
    @inlinable
    var isZero: Bool {
        return self.x.isZero == true && self.y.isZero == true
    }
    
    @inlinable
    var wrap: Self {
        return Point(x: self.y, y: self.x)
    }
    
    @inlinable
    var length: ValueType {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
}

public extension Point {
    
    @inlinable
    func distance(to: Self) -> ValueType {
        let x = self.x - to.x
        let y = self.y - to.y
        return sqrt(x * x + y * y)
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
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Point(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
}

extension Point : Comparable where ValueType: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
}
