//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum CircleToCircle : Equatable {
        case none
        case identical
        case one(PointType)
        case two(PointType, PointType)
    }
    
}

public extension Intersection2.CircleToCircle {
    
    @inlinable
    var point1: Intersection2.PointType? {
        switch self {
        case .one(let point): return point
        case .two(let point, _): return point
        default: return nil
        }
    }
    
    @inlinable
    var point2: Intersection2.PointType? {
        switch self {
        case .two(_, let point): return point
        default: return nil
        }
    }
    
}

public extension Intersection2 {
    
    @inlinable
    static func possibly(_ circle1: CircleType, _ circle2: CircleType) -> Bool {
        let cl = (circle1.origin - circle2.origin).length.real
        let sr = circle1.radius + circle2.radius
        return cl <= sr
    }
    
    static func find(_ circle1: CircleType, _ circle2: CircleType) -> CircleToCircle {
        let cmc = circle2.origin - circle1.origin
        let rmr = circle1.radius - circle2.radius
        let cdot = cmc.dot(cmc)
        if cdot ~~ 0 && rmr ~~ 0 {
            return .identical
        }
        let rmrqr = rmr * rmr
        if cdot < rmrqr {
            return .none
        }
        let rpr = circle1.radius + circle2.radius
        let rprqr = rpr * rpr
        if cdot > rprqr {
            return .none
        }
        if cdot < rprqr {
            if rmrqr < cdot {
                let icdot = 1 / cdot
                let s = 0.5 * ((circle1.radius * circle1.radius - circle2.radius * circle2.radius) * icdot + 1)
                let tmp = circle1.origin + s * cmc
                var d = circle1.radius * circle2.radius * icdot - s * s
                if d < 0 {
                    d = 0
                }
                let t = d.sqrt
                let v = PointType(x: cmc.y, y: -cmc.x)
                if t > 0 {
                    return .two(tmp - t * v, tmp + t * v)
                } else {
                    return .one(tmp - t * v)
                }
            }
            return .one(circle1.origin + (circle1.radius / rmr) * cmc)
        }
        return .one(circle1.origin + (circle1.radius / rpr) * cmc)
    }
    
}
