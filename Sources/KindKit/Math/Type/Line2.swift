//
//  KindKit
//

import Foundation

public struct Line2 : Hashable {
    
    public var origin: Point
    public var direction: Point
    
    public init(
        origin: Point,
        direction: Point
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
    func perpendicular(_ point: Point) -> Point {
        let n = self.direction.dot(point - self.origin)
        let d = self.direction.dot(self.direction)
        let b = (n / d)
        return self.origin + b * self.direction
    }
    
    @inlinable
    func distance(_ point: Point) -> Distance {
        let p = self.perpendicular(point)
        let d = point - p
        return Distance(squared: d.dot(d))
    }
    
}

public extension Line2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point) -> Self {
        return Line2(
            origin: lhs.origin + rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point) -> Self {
        return Line2(
            origin: lhs.origin - rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point) {
        lhs = lhs - rhs
    }
    
}
