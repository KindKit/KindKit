//
//  KindKitMath
//

import Foundation

public typealias Line2Float = Line2< Float >
public typealias Line2Double = Line2< Double >

public struct Line2< ValueType: IScalar & Hashable > : Hashable {
    
    public var origin: Point< ValueType >
    public var direction: Point< ValueType >
    
    @inlinable
    public init(
        origin: Point< ValueType >,
        direction: Point< ValueType >
    ) {
        self.origin = origin
        self.direction = direction
    }
    
}

public extension Line2 {
    
    @inlinable
    var invert: Self {
        return Line2(origin: self.origin, direction: self.direction.invert)
    }
    
}

public extension Line2 {
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Intersection2< ValueType >.LineToLine {
        return Intersection2.find(self, other)
    }
    
    @inlinable
    func isIntersects(_ other: Circle< ValueType >) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Circle< ValueType >) -> Intersection2< ValueType >.LineToCircle {
        return Intersection2.find(self, other)
    }
    
    @inlinable
    func isIntersects(_ other: Box2< ValueType >) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Box2< ValueType >) -> Intersection2< ValueType >.LineToBox {
        return Intersection2.find(self, other)
    }
    
    @inlinable
    func perpendicular(_ point: Point< ValueType >) -> Point< ValueType > {
        let n = self.direction.dot(point - self.origin)
        let d = self.direction.dot(self.direction)
        let b = (n / d)
        return self.origin + b * self.direction
    }
    
    @inlinable
    func distance(_ point: Point< ValueType >) -> Distance< ValueType > {
        let p = self.perpendicular(point)
        let d = point - p
        return Distance(squared: d.dot(d))
    }
    
}

public extension Line2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point< ValueType >) -> Self {
        return Line2(
            origin: lhs.origin + rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point< ValueType >) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point< ValueType >) -> Self {
        return Line2(
            origin: lhs.origin - rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point< ValueType >) {
        lhs = lhs - rhs
    }
    
}
