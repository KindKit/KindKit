//
//  KindKitMath
//

import Foundation

public typealias Box2Float = Box2< Float >
public typealias Box2Double = Box2< Double >

public struct Box2< Value: IScalar & Hashable > : Hashable {
    
    public var lower: Point< Value >
    public var upper: Point< Value >
    
    @inlinable
    public init() {
        self.lower = .zero
        self.upper = .zero
    }
    
    @inlinable
    public init(lower: Point< Value >, upper: Point< Value >) {
        self.lower = lower
        self.upper = upper
    }
    
    @inlinable
    public init(point1: Point< Value >, point2: Point< Value >) {
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
    var width: Value {
        return Swift.max(self.upper.x - self.lower.x, 0)
    }
    
    @inlinable
    var height: Value {
        return Swift.max(self.upper.y - self.lower.y, 0)
    }
    
    @inlinable
    var topLeft: Point< Value > {
        return Point(x: self.lower.x, y: self.lower.y)
    }
    
    @inlinable
    var top: Point< Value > {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y)
    }
    
    @inlinable
    var topRight: Point< Value > {
        return Point(x: self.upper.x, y: self.lower.y)
    }
    
    @inlinable
    var left: Point< Value > {
        return Point(x: self.lower.x, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var center: Point< Value > {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var right: Point< Value > {
        return Point(x: self.upper.x, y: self.lower.y + self.height / 2)
    }
    
    @inlinable
    var bottomLeft: Point< Value > {
        return Point(x: self.lower.x, y: self.upper.y)
    }
    
    @inlinable
    var bottom: Point< Value > {
        return Point(x: self.lower.x + self.width / 2, y: self.lower.y + self.height)
    }
    
    @inlinable
    var bottomRight: Point< Value > {
        return Point(x: self.upper.x, y: self.upper.y)
    }
    
    @inlinable
    var area: Value {
        let size = self.size
        return size.width * size.height
    }
    
    @inlinable
    var size: Size< Value > {
        return Size(width: self.width, height: self.height)
    }
    
    @inlinable
    var centeredForm: (center: Point< Value >, extend: Point< Value >) {
        return (
            center: (self.upper + self.lower) * 0.5,
            extend: (self.upper - self.lower) * 0.5
        )
    }
    
}

public extension Box2 {
    
    @inlinable
    func isContains(_ point: Point< Value >) -> Bool {
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
    func union(_ other: Point< Value >) -> Self {
        return Box2(
            lower: self.lower.min(other),
            upper: self.upper.max(other)
        )
    }
    
    @inlinable
    func inset(_ inset: Value) -> Self {
        return Box2(lower: self.lower - inset, upper: self.upper + inset)
    }
    
    @inlinable
    func inset(_ inset: Distance< Value >) -> Self {
        return self.inset(inset.real)
    }
    
}
