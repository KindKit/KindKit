//
//  KindKit
//

import Foundation

public struct Box2 : Hashable {
    
    public var lower: Point
    public var upper: Point
    
    public init() {
        self.lower = .zero
        self.upper = .zero
    }
    
    public init(lower: Point, upper: Point) {
        self.lower = lower
        self.upper = upper
    }
    
    public init(point1: Point, point2: Point) {
        self.lower = point1.min(point2)
        self.upper = point1.max(point2)
    }
    
}

public extension Box2 {
    
    @inlinable
    static var empty: Self {
        return Box2(lower: .infinity, upper: -.infinity)
    }
    
}

public extension Box2 {
    
    @inlinable
    var isEmpty: Bool {
        return self.lower.x > self.upper.x || self.lower.y > self.upper.y
    }
    
    @inlinable
    var width: Double {
        return Swift.max(self.upper.x - self.lower.x, 0)
    }
    
    @inlinable
    var height: Double {
        return Swift.max(self.upper.y - self.lower.y, 0)
    }
    
    @inlinable
    var topLeft: Point {
        return Point(x: self.lower.x, y: self.lower.y)
    }
    
    @inlinable
    var top: Point {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y)
    }
    
    @inlinable
    var topRight: Point {
        return Point(x: self.upper.x, y: self.lower.y)
    }
    
    @inlinable
    var left: Point {
        return Point(x: self.lower.x, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var center: Point {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var right: Point {
        return Point(x: self.upper.x, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var bottomLeft: Point {
        return Point(x: self.lower.x, y: self.upper.y)
    }
    
    @inlinable
    var bottom: Point {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y + self.height)
    }
    
    @inlinable
    var bottomRight: Point {
        return Point(x: self.upper.x, y: self.upper.y)
    }
    
    @inlinable
    var area: Double {
        let size = self.size
        return size.width * size.height
    }
    
    @inlinable
    var size: Size {
        return Size(width: self.width, height: self.height)
    }
    
    @inlinable
    var centeredForm: (center: Point, extend: Point) {
        return (
            center: (self.upper + self.lower) * 0.5,
            extend: (self.upper - self.lower) * 0.5
        )
    }
    
}

public extension Box2 {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        guard point.x >= self.lower.x && point.x <= self.upper.x else { return false }
        guard point.y >= self.lower.y && point.y <= self.upper.y else { return false }
        return true
    }
    
    @inlinable
    func union(_ other: Self) -> Self {
        return Box2(
            lower: self.lower.min(other.lower),
            upper: self.upper.max(other.upper)
        )
    }
    
    @inlinable
    func union(_ other: Point) -> Self {
        return Box2(
            lower: self.lower.min(other),
            upper: self.upper.max(other)
        )
    }
    
    @inlinable
    func inset(_ inset: Double) -> Self {
        return Box2(lower: self.lower - inset, upper: self.upper + inset)
    }
    
    @inlinable
    func inset(_ inset: Distance) -> Self {
        return self.inset(inset.real)
    }
    
}

extension Box2 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        let lower = self.lower.lerp(to.lower, progress: progress)
        let upper = self.upper.lerp(to.upper, progress: progress)
        return Box2(lower: lower, upper: upper)
    }
    
}
