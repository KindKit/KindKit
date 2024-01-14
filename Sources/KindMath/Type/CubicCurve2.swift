//
//  KindKit
//

import Foundation

public struct CubicCurve2 : Hashable {
    
    public var start: Point
    public var control1: Point
    public var control2: Point
    public var end: Point
    
    public init(
        start: Point,
        control1: Point,
        control2: Point,
        end: Point
    ) {
        self.start = start
        self.control1 = control1
        self.control2 = control2
        self.end = end
    }
    
    public init(_ line: Segment2) {
        self.start = line.start
        self.control1 = (1.0 / 3.0) * line.start + (1.0 / 3.0) * line.end
        self.control2 = (2.0 / 3.0) * line.start + (2.0 / 3.0) * line.end
        self.end = line.end
    }
    
    public init(_ curve: QuadCurve2) {
        self.start = curve.start
        self.control1 = (1.0 / 3.0) * curve.control + (1.0 / 3.0) * curve.end
        self.control2 = (2.0 / 3.0) * curve.start + (2.0 / 3.0) * curve.control
        self.end = curve.end
    }
    
}

public extension CubicCurve2 {
    
    var segment: ConvertCurve2< Segment2 > {
        let line = Segment2(start: self.start, end: self.end)
        let d1 = self.control1 - line.point(at: Percent(1.0 / 3.0))
        let d2 = self.control2 - line.point(at: Percent(2.0 / 3.0))
        let dmx = max(d1.x * d1.x, d2.x * d2.x)
        let dmy = max(d1.y * d1.y, d2.y * d2.y)
        return ConvertCurve2(
            curve: line,
            error: 3.0 / 4.0 * (dmx + dmy).sqrt
        )
    }
    
    var quadCurve: ConvertCurve2< QuadCurve2 > {
        let line = Segment2(start: self.start, end: self.end)
        let d1 = self.control1 - line.point(at: Percent(1.0 / 3.0))
        let d2 = self.control2 - line.point(at: Percent(2.0 / 3.0))
        let d = 0.5 * d1 + 0.5 * d2
        let control = 1.5 * d + line.point(at: .half)
        return ConvertCurve2(
            curve: QuadCurve2(start: line.start, control: control, end: line.end),
            error: 0.144334 * (d1 - d2).length.value
        )
    }
    
}

extension CubicCurve2 : ICurve2 {
    
    public var isSimple: Bool {
        guard self.start !~ self.control1 || self.control1 !~ self.control2 || self.control2 !~ self.end else { return true }
        let a1 = self.start.angle(self.end, self.control1)
        let a2 = self.start.angle(self.end, self.control2)
        if a1.radians > 0 && a2.radians < 0 || a1.radians < 0 && a2.radians > 0 {
            return false
        }
        let n1 = self.normal(at: .zero)
        let n2 = self.normal(at: .one)
        return n1.dot(n2).clamp(-1.0, 1.0).acos.abs < (.pi / 3.0)
    }
    
    @inlinable
    public var points: [Point] {
        return [ self.start, self.control1, self.control2, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return CubicCurve2(start: self.end, control1: self.control2, control2: self.control1, end: self.start)
    }
    
    public var length: Distance {
        return self.squaredLength.normal
    }
    
    public var squaredLength: Distance.Squared {
        return Bezier.squaredLength({
            let derivative = self.derivative(at: $0)
            return derivative.squaredLength
        })
    }
    
    public var bbox: AlignedBox2 {
        var lower = self.start.min(self.end)
        var upper = self.start.max(self.end)
        let ds = self.control1 - self.start
        let dc = self.control2 - self.control1
        let de = self.end - self.control2
        if self.control1.x < lower.x || self.control1.x > upper.x || self.control2.x < lower.x || self.control2.x > upper.x {
            Bezier.droots(ds.x, dc.x, de.x, closure: { k in
                guard k > 0.0 && k < 1.0 else { return }
                let v = self.point(at: Percent(k))
                if v.x < lower.x {
                    lower.x = v.x
                } else if v.x > upper.x {
                    upper.x = v.x
                }
            })
        }
        if self.control1.y < lower.y || self.control1.y > upper.y || self.control2.y < lower.y || self.control2.y > upper.y {
            Bezier.droots(ds.y, dc.y, de.y, closure: { k in
                guard k > 0.0 && k < 1.0 else { return }
                let v = self.point(at: Percent(k))
                if v.y < lower.y {
                    lower.y = v.y
                } else if v.y > upper.y {
                    upper.y = v.y
                }
            })
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
        let ll = location * 2
        let a = ill * il
        let b = ill * location * 3.0
        let c = il * ll * 3.0
        let d = location * ll
        return (a * self.start) + (b * self.control1) + (c * self.control2) + (d * self.end)
    }
    
    public func normal(at location: Percent) -> Point {
        var d = self.derivative(at: location)
        if d ~~ .zero && (location <= .zero || location >= .one) {
            if location ~~ .zero {
                d = self.control2 - self.start
            } else {
                d = self.end - self.control1
            }
            if d ~~ .zero {
                d = self.end - self.start
            }
        }
        return d.perpendicular.normalized.point
    }
    
    public func derivative(at location: Percent) -> Point {
        let il = location.invert
        let p0 = 3 * (self.control1 - self.start)
        let p1 = 3 * (self.control2 - self.control1)
        let p2 = 3 * (self.end - self.control2)
        let a = il * il
        let b = il * location * 2
        let c = location * location
        return (a * p0) + (b * p1) + (c * p2)
    }
    
    public func split(at location: Percent) -> (left: Self, right: Self) {
        let h0 = self.start
        let h1 = self.control1
        let h2 = self.control2
        let h3 = self.end
        let h4 = h0.lerp(h1, progress: location)
        let h5 = h1.lerp(h2, progress: location)
        let h6 = h2.lerp(h3, progress: location)
        let h7 = h4.lerp(h5, progress: location)
        let h8 = h5.lerp(h6, progress: location)
        let h9 = h7.lerp(h8, progress: location)
        return (
            left: CubicCurve2(start: h0, control1: h4, control2: h7, end: h9),
            right: CubicCurve2(start: h9, control1: h8, control2: h6, end: h3)
        )
    }
    
    public func cut(start: Percent, end: Percent) -> Self {
        guard start > .zero || end < .one else { return self }
        let k = (end - start) / 3.0
        let s = self.point(at: start)
        let e = self.point(at: end)
        let c1 = s + k * self.derivative(at: start)
        let c2 = e - k * self.derivative(at: end)
        return CubicCurve2(start: s, control1: c1, control2: c2, end: e)
    }
    
}

public extension CubicCurve2 {
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return CubicCurve2(
            start: lhs.start + rhs.start,
            control1: lhs.control1 + rhs.control1,
            control2: lhs.control2 + rhs.control2,
            end: lhs.end + rhs.end
        )
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Point) -> Self {
        return CubicCurve2(
            start: lhs.start + rhs,
            control1: lhs.control1 + rhs,
            control2: lhs.control2 + rhs,
            end: lhs.end + rhs
        )
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return CubicCurve2(
            start: lhs.start - rhs.start,
            control1: lhs.control1 - rhs.control1,
            control2: lhs.control2 - rhs.control2,
            end: lhs.end - rhs.end
        )
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Point) -> Self {
        return CubicCurve2(
            start: lhs.start - rhs,
            control1: lhs.control1 - rhs,
            control2: lhs.control2 - rhs,
            end: lhs.end - rhs
        )
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return CubicCurve2(
            start: lhs.start * rhs,
            control1: lhs.control1 * rhs,
            control2: lhs.control2 * rhs,
            end: lhs.end * rhs
        )
    }
    
}

extension CubicCurve2 : IMapable {
}

extension CubicCurve2 : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            start: self.start.lerp(to.start, progress: progress),
            control1: self.control1.lerp(to.control1, progress: progress),
            control2: self.control2.lerp(to.control2, progress: progress),
            end: self.end.lerp(to.end, progress: progress)
        )
    }
    
}
