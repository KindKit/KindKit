//
//  KindKit
//

import KindNumeric

public struct Point {
    
    public var x: Coordinate
    public var y: Coordinate
    
    public init(x: Coordinate, y: Coordinate) {
        self.x = x
        self.y = y
    }
    
    public init(both: Coordinate) {
        self.x = both
        self.y = both
    }
    
    public init(_ size: Size) {
        self.x = size.width
        self.y = size.height
    }
    
}

extension Point : Hashable {
}

extension Point : Equatable {
}

extension Point : Sendable {
}

public extension Point {
    
    @inlinable
    var swap: Self {
        return .init(
            x: self.y,
            y: self.x
        )
    }
    
    @inlinable
    var perpendicular: Self {
        return .init(
            x: self.y,
            y: self.x.negating()
        )
    }
    
    @inlinable
    var dot: Coordinate {
        return self.dot(self)
    }
    
    @inlinable
    var length: Distance {
        return self.squaredLength.distance
    }
    
    @inlinable
    var squaredLength: SquaredDistance {
        return .init(self.dot)
    }
    
    @inlinable
    var cross: Coordinate {
        return self.cross(self)
    }
    
    @inlinable
    var angle: Radian {
        return .init(self.y.atan2(self.x))
    }
    
}

public extension Point {
    
    @inlinable
    func cross(_ other: Self) -> Coordinate {
        return self.x * other.y - self.y * other.x
    }
    
    @inlinable
    func dot(_ other: Self) -> Coordinate {
        return self.x * other.x + self.y * other.y
    }
    
    @inlinable
    func length(_ other: Self) -> Distance {
        return self.squaredLength(other).distance
    }
    
    @inlinable
    func squaredLength(_ other: Self) -> SquaredDistance {
        return (self - other).squaredLength
    }
    
    @inlinable
    func angle(_ point1: Self, _ point2: Self) -> Radian {
        let d1 = point1 - self
        let d2 = point2 - self
        return .init(d1.cross(d2).atan2(d1.dot(d2)))
    }
    
}
