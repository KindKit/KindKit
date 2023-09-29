//
//  KindKit
//

import Foundation

public struct QuadCurve2 : Hashable {
    
    public var start: Point
    public var control: Point
    public var end: Point
    
    public init(
        start: Point,
        control: Point,
        end: Point
    ) {
        self.start = start
        self.control = control
        self.end = end
    }
    
    public init(_ line: Segment2) {
        self.start = line.start
        self.control = Percent.half * (line.start + line.end)
        self.end = line.end
    }
    
}

public extension QuadCurve2 {
    
    var segment: ConvertCurve2< Segment2 > {
        let line = Segment2(start: self.start, end: self.end)
        return ConvertCurve2(
            curve: line,
            error: 0.5 * (self.control - line.point(at: .half)).length.value
        )
    }
    
}

extension QuadCurve2 : ICurve2 {
    
    public var isSimple: Bool {
        guard self.start !~ self.control || self.control !~ self.end else { return true }
        let n1 = self.normal(at: .zero)
        let n2 = self.normal(at: .one)
        let s = n1.dot(n2).clamp(-1.0, 1.0)
        let a = s.acos.abs
        return a < (Double.pi / 3)
    }
    
    @inlinable
    public var points: [Point] {
        return [ self.start, self.control, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return QuadCurve2(start: self.end, control: self.control, end: self.start)
    }
    
    public var length: Distance {
        return self.squaredLength.normal
    }
    
    public var squaredLength: Distance.Squared {
        return Bezier.squaredLength({
            let d = self.derivative(at: $0)
            return d.squaredLength
        })
    }
    
    public var bbox: AlignedBox2 {
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
        return .init(lower: lower, upper: upper)
    }
    
    public func point(at location: Percent) -> Point {
        if location <= .zero {
            return self.start
        } else if location >= .one {
            return self.end
        }
        let il = location.invert
        let ill = il * il
        let a = ill
        let b = il * (location * 2)
        let c = location * location
        return (a * self.start) + (b * self.control) + (c * self.end)
    }
    
    public func normal(at location: Percent) -> Point {
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
    
    public func derivative(at location: Percent) -> Point {
        let a = location.invert
        let b = location
        let s = 2 * (self.control - self.start)
        let e = 2 * (self.end - self.control)
        return (a * s) + (b * e)
    }
    
    public func split(at location: Percent) -> (left: Self, right: Self) {
        let ss = self.start
        let sc = self.control
        let se = self.end
        let es = ss.lerp(sc, progress: location)
        let ec = sc.lerp(se, progress: location)
        let ee = es.lerp(ec, progress: location)
        return (
            left: QuadCurve2(start: ss, control: es, end: ee),
            right: QuadCurve2(start: ee, control: ec, end: se)
        )
    }
    
    public func cut(start: Percent, end: Percent) -> Self {
        guard start > .zero || end < .one else { return self }
        let k = (end - start) / 2
        let s = self.point(at: start)
        let e = self.point(at: end)
        let c = (s + e) / 2 + k / 2 * (self.derivative(at: start) - self.derivative(at: end))
        return QuadCurve2(start: s, control: c, end: e)
    }
    
}

public extension QuadCurve2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Point) -> Self {
        return QuadCurve2(
            start: lhs.start + rhs,
            control: lhs.control + rhs,
            end: lhs.end + rhs
        )
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point) -> Self {
        return QuadCurve2(
            start: lhs.start - rhs,
            control: lhs.control - rhs,
            end: lhs.end - rhs
        )
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return QuadCurve2(
            start: lhs.start * rhs,
            control: lhs.control * rhs,
            end: lhs.end * rhs
        )
    }
    
}

extension QuadCurve2 : IMapable {
}

extension QuadCurve2 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            start: self.start.lerp(to.start, progress: progress),
            control: self.control.lerp(to.control, progress: progress),
            end: self.end.lerp(to.end, progress: progress)
        )
    }
    
}
