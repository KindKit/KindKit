//
//  KindKitMath
//

import Foundation

public typealias QuadCurve2Float = QuadCurve2< Float >
public typealias QuadCurve2Double = QuadCurve2< Double >

public struct QuadCurve2< ValueType: IScalar & Hashable > : Hashable {
    
    public var start: Point< ValueType >
    public var control: Point< ValueType >
    public var end: Point< ValueType >
    
    public init(
        start: Point< ValueType >,
        control: Point< ValueType >,
        end: Point< ValueType >
    ) {
        self.start = start
        self.control = control
        self.end = end
    }
    
    public init(_ line: Segment2< ValueType >) {
        self.start = line.start
        self.control = 0.5 * (line.start + line.end)
        self.end = line.end
    }
    
}

public extension QuadCurve2 {
    
    var segment: ConvertCurve2< Segment2< ValueType > > {
        let line = Segment2(start: self.start, end: self.end)
        return ConvertCurve2(
            curve: line,
            error: 0.5 * (self.control - line.point(at: .half)).length.real
        )
    }
    
}

public extension QuadCurve2 {
    
    @inlinable
    func closest(_ point: Point< ValueType >) -> Percent< ValueType > {
        return Closest2.find(point, self)
    }
    
}

extension QuadCurve2 : ICurve2 {
    
    public var isSimple: Bool {
        guard self.start !~ self.control || self.control !~ self.end else { return true }
        let n1 = self.normal(at: .zero)
        let n2 = self.normal(at: .one)
        let s = n1.dot(n2).clamp(-1.0, 1.0)
        let a = s.acos.abs
        return a < (ValueType.pi / 3)
    }
    
    @inlinable
    public var points: [Point< ValueType >] {
        return [ self.start, self.control, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return QuadCurve2(start: self.end, control: self.control, end: self.start)
    }
    
    public var length: Distance< ValueType > {
        return Distance(squared: ValueType(Bezier.length({
            let d = self.derivative(at: Percent(ValueType($0)))
            return d.length.squared.double
        })))
    }
    
    public var bbox: Box2< ValueType > {
        var lower = self.start.min(self.end)
        var upper = self.start.max(self.end)
        let ds = self.control - self.start
        let de = self.end - self.control
        if ds.x !~ de.x {
            let k = ds.x / (ds.x - de.x)
            let v = self.point(at: Percent(k))
            if v.x < lower.x {
                lower.x = v.x
            } else if v.x > upper.x {
                upper.x = v.x
            }
        }
        if ds.y !~ de.y {
            let k = ds.y / (ds.y - de.y)
            let v = self.point(at: Percent(k))
            if v.y < lower.y {
                lower.y = v.y
            } else if v.y > upper.y {
                upper.y = v.y
            }
        }
        return Box2(lower: lower, upper: upper)
    }
    
    public func point(at location: Percent< ValueType >) -> Point< ValueType > {
        if location <= .zero {
            return self.start
        } else if location >= .one {
            return self.end
        }
        let il = 1 - location.value
        let ill = il * il
        let a = ill
        let b = il * (location.value * 2)
        let c = location.value * location.value
        return (a * self.start) + (b * self.control) + (c * self.end)
    }
    
    public func normal(at location: Percent< ValueType >) -> Point< ValueType > {
        var d = self.derivative(at: location)
        if d ~~ .zero && (location <= .zero || location >= .one) {
            if location ~~ .zero {
                d = self.end - self.control
            } else {
                d = self.control - self.start
            }
        }
        return d.perpendicular.normalized.point
    }
    
    public func derivative(at location: Percent< ValueType >) -> Point< ValueType > {
        let a = 1 - location.value
        let b = location.value
        let s = 2 * (self.control - self.start)
        let e = 2 * (self.end - self.control)
        return (a * s) + (b * e)
    }
    
    public func split(at location: Percent< ValueType >) -> (left: Self, right: Self) {
        let ss = self.start
        let sc = self.control
        let se = self.end
        let es = ss.lerp(sc, progress: location.value)
        let ec = sc.lerp(se, progress: location.value)
        let ee = es.lerp(ec, progress: location.value)
        return (
            left: QuadCurve2(start: ss, control: es, end: ee),
            right: QuadCurve2(start: ee, control: ec, end: se)
        )
    }
    
    public func cut(start: Percent< ValueType >, end: Percent< ValueType >) -> Self {
        guard start > .zero || end < .one else { return self }
        let k = (end.value - start.value) / 2
        let s = self.point(at: start)
        let e = self.point(at: end)
        let c = (s + e) / 2 + k / 2 * (self.derivative(at: start) - self.derivative(at: end))
        return QuadCurve2(start: s, control: c, end: e)
    }
    
}

public extension QuadCurve2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point< ValueType >) -> Self {
        return QuadCurve2(
            start: lhs.start + rhs,
            control: lhs.control + rhs,
            end: lhs.end + rhs
        )
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point< ValueType >) -> Self {
        return QuadCurve2(
            start: lhs.start - rhs,
            control: lhs.control - rhs,
            end: lhs.end - rhs
        )
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3< ValueType >) -> Self {
        return QuadCurve2(
            start: lhs.start * rhs,
            control: lhs.control * rhs,
            end: lhs.end * rhs
        )
    }
    
}
