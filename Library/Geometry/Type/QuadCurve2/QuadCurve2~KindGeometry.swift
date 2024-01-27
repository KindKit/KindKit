//
//  KindKit
//

import KindNumeric

extension QuadCurve2 : Curve2Trait {
    
    public var isSimple: Bool {
        guard self.start.isNearNotEqual(self.control) || self.end.isNearNotEqual(self.control) else { return true }
        let n1 = self.normal(at: .min)
        let n2 = self.normal(at: .max)
        let s = n1.dot(n2).clamp(.init(-1), .init(1))
        let a = s.acos.abs
        return a < (Coordinate.pi / 3)
    }
    
    @inlinable
    public var points: [Point] {
        return [ self.start, self.control, self.end ]
    }
    
    @inlinable
    public var inverse: Self {
        return .init(start: self.end, control: self.control, end: self.start)
    }
    
    public var length: Distance {
        return .init(self.squaredLength)
    }
    
    public var squaredLength: SquaredDistance {
        let squaredLength = Bezier.squaredLength({
            return self.derivative(at: .init($0)).squaredLength.value.float64
        })
        return .init(squaredLength)
    }
    
    public var bbox: AlignedBox2 {
        var lower = self.start.min(self.end)
        var upper = self.start.max(self.end)
        let ds = self.control - self.start
        let de = self.end - self.control
        if ds.x.isNearNotEqual(de.x) {
            let k = ds.x / (ds.x - de.x)
            let v = self.point(at: .init(k))
            if v.x < lower.x {
                lower.x = v.x
            } else if v.x > upper.x {
                upper.x = v.x
            }
        }
        if ds.y.isNearNotEqual(de.y) {
            let k = ds.y / (ds.y - de.y)
            let v = self.point(at: .init(k))
            if v.y < lower.y {
                lower.y = v.y
            } else if v.y > upper.y {
                upper.y = v.y
            }
        }
        return .init(
            lower: lower,
            upper: upper
        )
    }
    
    public func point(at location: Percent) -> Point {
        if location <= .min {
            return self.start
        } else if location >= .max {
            return self.end
        }
        let il = location.invert
        let ill = il * il
        let a = ill
        let b = il * location.doubled()
        let c = location * location
        return (self.start * a) + (self.control * b) + (self.end * c)
    }
    
    public func normal(at location: Percent) -> Point {
        var d = self.derivative(at: location)
        if d.isNearZero && (location <= .min || location >= .max) {
            if location.isNearMin {
                d = self.end - self.control
            } else {
                d = self.control - self.start
            }
        }
        return d.perpendicular.normalized.point
    }
    
    @inlinable
    public func offset(at: Percent, distance: Distance) -> Point {
        let point = self.point(at: at)
        let normal = self.normal(at: at)
        return point.adding(on: normal.multiplying(by: distance))
    }
    
    public func derivative(at location: Percent) -> Point {
        let a = location.invert
        let b = location
        let s = (self.control - self.start).doubled()
        let e = (self.end - self.control).doubled()
        return (s * a) + (e * b)
    }
    
    public func split(at location: Percent) -> (left: Self, right: Self) {
        let ss = self.start
        let sc = self.control
        let se = self.end
        let es = ss.lerp(sc, by: location)
        let ec = sc.lerp(se, by: location)
        let ee = es.lerp(ec, by: location)
        return (
            left: .init(start: ss, control: es, end: ee),
            right: .init(start: ee, control: ec, end: se)
        )
    }
    
    public func cut(start: Percent, end: Percent) -> Self {
        guard start > .min || end < .max else { return self }
        let k = (end - start).halved()
        let s = self.point(at: start)
        let e = self.point(at: end)
        let c = (s + e).halved() + ((self.derivative(at: start) - self.derivative(at: end)) * k.halved())
        return .init(
            start: s,
            control: c,
            end: e
        )
    }
    
}

extension QuadCurve2 : SubPointTrait {
    
    @inlinable
    public func subtracting(this point: Point) -> Self {
        return .init(
            start: self.start.subtracting(this: point),
            control: self.control.subtracting(this: point),
            end: self.end.subtracting(this: point)
        )
    }
    
}

extension QuadCurve2 : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(
            start: self.start.multiplying(by: matrix),
            control: self.control.multiplying(by: matrix),
            end: self.end.multiplying(by: matrix)
        )
    }
    
}
