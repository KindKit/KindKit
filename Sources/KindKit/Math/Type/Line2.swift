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
    
    public init(
        origin: Point,
        angle: Angle
    ) {
        self.origin = origin
        self.direction = Point(x: 1, y: 0).rotated(by: angle)
    }
    
}

public extension Line2 {
    
    @inlinable
    var invert: Self {
        return .init(origin: self.origin, direction: self.direction.invert)
    }
    
}

public extension Line2 {
    
    @inlinable
    func perpendicular(_ point: Point) -> Point {
        let n = self.direction.dot(point - self.origin)
        let d = self.direction.dot(self.direction)
        return self.origin + (n / d) * self.direction
    }
    
    @inlinable
    func distance(_ point: Point) -> Distance {
        return self.squaredDistance(point).normal
    }
    
    @inlinable
    func rotated(by angle: Angle, around center: Point = .zero) -> Self {
        return self.rotated(by: Matrix3(rotation: angle), around: center)
    }
    
    @inlinable
    func rotated(by matrix: Matrix3, around center: Point = .zero) -> Self {
        return .init(
            origin: self.origin.rotated(by: matrix, around: center),
            direction: self.direction.rotated(by: matrix)
        )
    }

    @inlinable
    func squaredDistance(_ point: Point) -> Distance.Squared {
        let p = self.perpendicular(point)
        let d = point - p
        return .init(d.dot(d))
    }
    
}

public extension Line2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point) -> Self {
        return .init(
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
        return .init(
            origin: lhs.origin - rhs,
            direction: lhs.direction
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point) {
        lhs = lhs - rhs
    }
    
}

extension Line2 : IMapable {
}

extension Line2 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            origin: self.origin.lerp(to.origin, progress: progress),
            direction: self.direction.lerp(to.direction, progress: progress)
        )
    }
    
}
