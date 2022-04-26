//
//  KindKitMath
//

import Foundation

public typealias Segment2Float = Segment2< Float >
public typealias Segment2Double = Segment2< Double >

public struct Segment2< ValueType: IScalar & Hashable > : Hashable {
    
    public var start: Point< ValueType >
    public var end: Point< ValueType >
    
    public init(
        start: Point< ValueType >,
        end: Point< ValueType >
    ) {
        self.start = start
        self.end = end
    }
    
}

public extension Segment2 {
    
    @inlinable
    var center: Point< ValueType > {
        return self.start + (self.delta / 2)
    }
    
    @inlinable
    var delta: Point< ValueType > {
        return self.end - self.start
    }
    
    @inlinable
    var centeredForm: (center: Point< ValueType >, direction: Point< ValueType >, extend: ValueType) {
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
    var line: Line2< ValueType > {
        let cf = self.centeredForm
        return Line2(origin: cf.center, direction: cf.direction)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Intersection2< ValueType >.SegmentToSegment {
        return Intersection2.find(self, other)
    }
    
    @inlinable
    func closest(_ point: Point< ValueType >) -> Percent< ValueType > {
        return Closest2.find(point, self)
    }
    
    @inlinable
    func direction(_ point: Point< ValueType >) -> ValueType {
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
    public var points: [Point< ValueType >] {
        return [ self.start, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return Segment2(start: self.end, end: self.start)
    }
    
    @inlinable
    public var length: Distance< ValueType > {
        return self.end.distance(self.start)
    }
    
    @inlinable
    public var bbox: Box2< ValueType > {
        return Box2(point1: self.start, point2: self.end)
    }
    
    @inlinable
    public func point(at location: Percent< ValueType >) -> Point< ValueType > {
        if location <= .zero {
            return self.start
        } else if location >= .one {
            return self.end
        }
        return self.start.lerp(self.end, progress: location.value)
    }
    
    @inlinable
    public func normal(at location: Percent< ValueType >) -> Point< ValueType > {
        return self.delta.perpendicular.normalized.point
    }
    
    @inlinable
    public func derivative(at location: Percent< ValueType >) -> Point< ValueType > {
        return self.delta
    }
    
    @inlinable
    public func split(at location: Percent< ValueType >) -> (left: Self, right: Self) {
        let center = self.start.lerp(self.end, progress: location.value)
        return (
            left: Segment2(start: self.start, end: center),
            right: Segment2(start: center, end: self.end)
        )
    }
    
    @inlinable
    public func cut(start: Percent< ValueType >, end: Percent< ValueType >) -> Self {
        return Segment2(start: self.point(at: start), end: self.point(at: end))
    }
    
}

public extension Segment2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point< ValueType >) -> Self {
        return Segment2(
            start: lhs.start + rhs,
            end: lhs.end + rhs
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point< ValueType >) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point< ValueType >) -> Self {
        return Segment2(
            start: lhs.start - rhs,
            end: lhs.end - rhs
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point< ValueType >) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3< ValueType >) -> Self {
        return Segment2(
            start: lhs.start * rhs,
            end: lhs.end * rhs
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3< ValueType >) {
        lhs = lhs * rhs
    }
    
}
