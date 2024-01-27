//
//  KindKit
//

import KindNumeric

public struct Line2 : Hashable, Equatable {
    
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
    init(
        origin: Point,
        angle: Radian
    ) {
        self.init(
            origin: origin,
            direction: Point(x: .one, y: .zero).rotated(by: angle)
        )
    }
    
}

public extension Line2 {
    
    @inlinable
    func perpendicular(_ point: Point) -> Point {
        let n = self.direction.dot(point - self.origin)
        let d = self.direction.dot(self.direction)
        let k = n / d
        return self.origin + (self.direction * Point(both: k))
    }
    
    @inlinable
    func distance(_ point: Point) -> Distance {
        return .init(self.squaredDistance(point))
    }
    
    @inlinable
    func squaredDistance(_ point: Point) -> SquaredDistance {
        let p = self.perpendicular(point)
        let d = point - p
        return .init(d.dot(d))
    }
    
}
