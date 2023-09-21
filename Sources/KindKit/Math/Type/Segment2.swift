//
//  KindKit
//

import Foundation

public struct Segment2 : Hashable {
    
    public var start: Point
    public var end: Point
    
    public init(
        start: Point,
        end: Point
    ) {
        self.start = start
        self.end = end
    }
    
}

public extension Segment2 {
    
    @inlinable
    var center: Point {
        return self.start + (self.delta * Percent.half)
    }
    
    @inlinable
    var delta: Point {
        return self.end - self.start
    }
    
    @inlinable
    var centeredForm: (center: Point, direction: Point, extend: Double) {
        set {
            self.start = newValue.center - Distance(newValue.extend) * newValue.direction
            self.end = newValue.center + Distance(newValue.extend) * newValue.direction
        }
        get {
            let n = self.delta.normalized
            return (
                center: Percent.half * (self.start + self.end),
                direction: n.point,
                extend: 0.5 * n.length.value
            )
        }
    }
    
    @inlinable
    var line: Line2 { 
        let cf = self.centeredForm
        return Line2(origin: cf.center, direction: cf.direction)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func direction(_ point: Point) -> Double {
        let d = self.end - self.start
        let p = point - self.start
        let c = d.cross(p)
        if c > 0 {
            return 1
        } else if c < 0 {
            return -1
        }
        return 0
    }
    
}

extension Segment2 : ICurve2 {
    
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
        return Segment2(start: self.end, end: self.start)
    }
    
    @inlinable
    public var length: Distance {
        return self.end.distance(self.start)
    }
    
    @inlinable
    public var bbox: Box2 {
        return Box2(point1: self.start, point2: self.end)
    }
    
    @inlinable
    public func point(at location: Percent) -> Point {
        if location <= .zero {
            return self.start
        } else if location >= .one {
            return self.end
        }
        return self.start.lerp(self.end, progress: location)
    }
    
    @inlinable
    public func normal(at location: Percent) -> Point {
        return self.delta.perpendicular.normalized.point
    }
    
    @inlinable
    public func derivative(at location: Percent) -> Point {
        return self.delta
    }
    
    @inlinable
    public func split(at location: Percent) -> (left: Self, right: Self) {
        let center = self.start.lerp(self.end, progress: location)
        return (
            left: Segment2(start: self.start, end: center),
            right: Segment2(start: center, end: self.end)
        )
    }
    
    @inlinable
    public func cut(start: Percent, end: Percent) -> Self {
        return Segment2(start: self.point(at: start), end: self.point(at: end))
    }
    
}

public extension Segment2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point) -> Self {
        return Segment2(
            start: lhs.start + rhs,
            end: lhs.end + rhs
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point) -> Self {
        return Segment2(
            start: lhs.start - rhs,
            end: lhs.end - rhs
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return Segment2(
            start: lhs.start * rhs,
            end: lhs.end * rhs
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs * rhs
    }
    
}
