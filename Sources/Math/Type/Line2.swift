//
//  KindKitMath
//

import Foundation

public typealias Line2Float = Line2< Float >
public typealias Line2Double = Line2< Double >

public struct Line2< Value: IScalar & Hashable > : Hashable {
    
    public var origin: Point< Value >
    public var direction: Point< Value >
    
    @inlinable
    public init(
        origin: Point< Value >,
        direction: Point< Value >
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
    func perpendicular(_ point: Point< Value >) -> Point< Value > {
        let n = self.direction.dot(point - self.origin)
        let d = self.direction.dot(self.direction)
        let b = (n / d)
        return self.origin + b * self.direction
    }
    
    @inlinable
    func distance(_ point: Point< Value >) -> Distance< Value > {
        let p = self.perpendicular(point)
        let d = point - p
        return Distance(squared: d.dot(d))
    }
    
}

public extension Line2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point< Value >) -> Self {
        return Line2(
            origin: lhs.origin + rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point< Value >) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point< Value >) -> Self {
        return Line2(
            origin: lhs.origin - rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point< Value >) {
        lhs = lhs - rhs
    }
    
}
