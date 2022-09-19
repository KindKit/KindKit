//
//  KindKit
//

import Foundation

public typealias Segment2Float = Segment2< Float >
public typealias Segment2Double = Segment2< Double >

public struct Segment2< Value : IScalar & Hashable > : Hashable {
    
    public var start: Point< Value >
    public var end: Point< Value >
    
    public init(
        start: Point< Value >,
        end: Point< Value >
    ) {
        self.start = start
        self.end = end
    }
    
}

public extension Segment2 {
    
    @inlinable
    var center: Point< Value > {
        return self.start + (self.delta / 2)
    }
    
    @inlinable
    var delta: Point< Value > {
        return self.end - self.start
    }
    
    @inlinable
    var centeredForm: (center: Point< Value >, direction: Point< Value >, extend: Value) {
        set(value) {
            self.start = value.center - value.extend * value.direction
            self.end = value.center + value.extend * value.direction
        }
        get {
            let n = self.delta.normalized
            return (
                center: 0.5 * (self.start + self.end),
                direction: n.point,
                extend: 0.5 * n.length.real
            )
        }
    }
    
    @inlinable
    var line: Line2< Value > {
        let cf = self.centeredForm
        return Line2(origin: cf.center, direction: cf.direction)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func direction(_ point: Point< Value >) -> Value {
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
    public var points: [Point< Value >] {
        return [ self.start, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return Segment2(start: self.end, end: self.start)
    }
    
    @inlinable
    public var length: Distance< Value > {
        return self.end.distance(self.start)
    }
    
    @inlinable
    public var bbox: Box2< Value > {
        return Box2(point1: self.start, point2: self.end)
    }
    
    @inlinable
    public func point(at location: Percent< Value >) -> Point< Value > {
        if location <= .zero {
            return self.start
        } else if location >= .one {
            return self.end
        }
        return self.start.lerp(self.end, progress: location.value)
    }
    
    @inlinable
    public func normal(at location: Percent< Value >) -> Point< Value > {
        return self.delta.perpendicular.normalized.point
    }
    
    @inlinable
    public func derivative(at location: Percent< Value >) -> Point< Value > {
        return self.delta
    }
    
    @inlinable
    public func split(at location: Percent< Value >) -> (left: Self, right: Self) {
        let center = self.start.lerp(self.end, progress: location.value)
        return (
            left: Segment2(start: self.start, end: center),
            right: Segment2(start: center, end: self.end)
        )
    }
    
    @inlinable
    public func cut(start: Percent< Value >, end: Percent< Value >) -> Self {
        return Segment2(start: self.point(at: start), end: self.point(at: end))
    }
    
}

public extension Segment2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point< Value >) -> Self {
        return Segment2(
            start: lhs.start + rhs,
            end: lhs.end + rhs
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point< Value >) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point< Value >) -> Self {
        return Segment2(
            start: lhs.start - rhs,
            end: lhs.end - rhs
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point< Value >) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3< Value >) -> Self {
        return Segment2(
            start: lhs.start * rhs,
            end: lhs.end * rhs
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3< Value >) {
        lhs = lhs * rhs
    }
    
}
