//
//  KindKit
//

import KindNumeric

extension CubicCurve2 : Curve2Trait {
    
    public var isSimple: Bool {
        guard self.start.isNearNotEqual(self.control1) || self.control1.isNearNotEqual(self.control2) || self.end.isNearNotEqual(self.control2) else { return true }
        let a1 = self.start.angle(self.end, self.control1)
        let a2 = self.start.angle(self.end, self.control2)
        if a1 > .zero && a2 < .zero || a1 < .zero && a2 > .zero {
            return false
        }
        let n1 = self.normal(at: .min)
        let n2 = self.normal(at: .max)
        return n1.dot(n2).clamp(Coordinate(-1), Coordinate(1)).acos.abs < (Coordinate.pi / 3)
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
        let ds = self.control1 - self.start
        let dc = self.control2 - self.control1
        let de = self.end - self.control2
        if self.control1.x < lower.x || self.control1.x > upper.x || self.control2.x < lower.x || self.control2.x > upper.x {
            Bezier.droots(ds.x.float64, dc.x.float64, de.x.float64, closure: { k in
                guard k > 0.0 && k < 1.0 else { return }
                let v = self.point(at: .init(k))
                if v.x < lower.x {
                    lower.x = v.x
                } else if v.x > upper.x {
                    upper.x = v.x
                }
            })
        }
        if self.control1.y < lower.y || self.control1.y > upper.y || self.control2.y < lower.y || self.control2.y > upper.y {
            Bezier.droots(ds.y.float64, dc.y.float64, de.y.float64, closure: { k in
                guard k > 0.0 && k < 1.0 else { return }
                let v = self.point(at: .init(k))
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
        if location <= .min {
            return self.start
        } else if location >= .max {
            return self.end
        }
        let il = location.invert
        let dil = il * il
        let ll = location.doubled()
        let a = dil * il
        let b = dil * location * Percent(3)
        let c = il * ll * Percent(3)
        let d = location * ll
        let ra = a * self.start
        let rb = b * self.control1
        let rc = c * self.control2
        let rd = d * self.end
        return ra + rb + rc + rd
    }
    
    public func normal(at location: Percent) -> Point {
        var d = self.derivative(at: location)
        if d.isNearZero && (location <= .min || location >= .max) {
            if location.isNearMin {
                d = self.control2 - self.start
            } else {
                d = self.end - self.control1
            }
            if d.isNearZero {
                d = self.end - self.start
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
        let il = location.invert
        let p0 = Percent(3) * (self.control1 - self.start)
        let p1 = Percent(3) * (self.control2 - self.control1)
        let p2 = Percent(3) * (self.end - self.control2)
        let a = il * il
        let b = il * location.doubled()
        let c = location * location
        return (a * p0) + (b * p1) + (c * p2)
    }
    
    public func split(at location: Percent) -> (left: Self, right: Self) {
        let h0 = self.start
        let h1 = self.control1
        let h2 = self.control2
        let h3 = self.end
        let h4 = h0.lerp(h1, by: location)
        let h5 = h1.lerp(h2, by: location)
        let h6 = h2.lerp(h3, by: location)
        let h7 = h4.lerp(h5, by: location)
        let h8 = h5.lerp(h6, by: location)
        let h9 = h7.lerp(h8, by: location)
        return (
            left: .init(start: h0, control1: h4, control2: h7, end: h9),
            right: .init(start: h9, control1: h8, control2: h6, end: h3)
        )
    }
    
    public func cut(start: Percent, end: Percent) -> Self {
        guard start > .min || end < .max else { return self }
        let k = (end - start) / Percent(3)
        let s = self.point(at: start)
        let e = self.point(at: end)
        let c1 = s + k * self.derivative(at: start)
        let c2 = e - k * self.derivative(at: end)
        return .init(start: s, control1: c1, control2: c2, end: e)
    }
    
}

extension CubicCurve2 : SubPointTrait {
    
    @inlinable
    public func subtracting(this point: Point) -> Self {
        return .init(
            start: self.start.subtracting(this: point),
            control1: self.control1.subtracting(this: point),
            control2: self.control2.subtracting(this: point),
            end: self.end.subtracting(this: point)
        )
    }
    
}

extension CubicCurve2 : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(
            start: self.start.multiplying(by: matrix),
            control1: self.control1.multiplying(by: matrix),
            control2: self.control2.multiplying(by: matrix),
            end: self.end.multiplying(by: matrix)
        )
    }
    
}
