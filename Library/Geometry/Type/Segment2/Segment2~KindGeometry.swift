//
//  KindKit
//

import KindNumeric

extension Segment2 : Curve2Trait {
    
    @inlinable
    public var isSimple: Bool {
        return true
    }
    
    @inlinable
    public var points: [Point] {
        return [ self.start, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return .init(start: self.end, end: self.start)
    }
    
    @inlinable
    public var length: Distance {
        return self.end.length(self.start)
    }
    
    @inlinable
    public var squaredLength: SquaredDistance {
        return self.end.squaredLength(self.start)
    }
    
    @inlinable
    public var bbox: AlignedBox2 {
        return .init(point1: self.start, point2: self.end)
    }
    
    @inlinable
    public func point(at location: Percent) -> Point {
        if location <= .min {
            return self.start
        } else if location >= .max {
            return self.end
        }
        return self.start.lerp(self.end, by: location)
    }
    
    @inlinable
    public func normal(at location: Percent) -> Point {
        return self.normal
    }
    
    @inlinable
    public func offset(at: Percent, distance: Distance) -> Point {
        let point = self.point(at: at)
        let normal = self.normal(at: at)
        return point.adding(on: normal.multiplying(by: distance))
    }
    
    @inlinable
    public func derivative(at location: Percent) -> Point {
        return self.delta
    }
    
    @inlinable
    public func split(at location: Percent) -> (left: Self, right: Self) {
        let center = self.start.lerp(self.end, by: location)
        return (
            left: .init(start: self.start, end: center),
            right: .init(start: center, end: self.end)
        )
    }
    
    @inlinable
    public func cut(start: Percent, end: Percent) -> Self {
        return .init(
            start: self.point(at: start),
            end: self.point(at: end)
        )
    }
    
}

extension Segment2 : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(
            start: self.start.multiplying(by: matrix),
            end: self.end.multiplying(by: matrix)
        )
    }
    
}
