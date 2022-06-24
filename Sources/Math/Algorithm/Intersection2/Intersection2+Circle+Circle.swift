//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum CircleToCircle : Equatable {
        case none
        case identical
        case one(Point< Value >)
        case two(Point< Value >, Point< Value >)
    }
    
}

public extension Intersection2.CircleToCircle {
    
    @inlinable
    var point1: Point< Value >? {
        switch self {
        case .one(let point): return point
        case .two(let point, _): return point
        default: return nil
        }
    }
    
    @inlinable
    var point2: Point< Value >? {
        switch self {
        case .two(_, let point): return point
        default: return nil
        }
    }
    
}

public extension Intersection2 {
    
    @inlinable
    static func possibly(_ circle1: Circle< Value >, _ circle2: Circle< Value >) -> Bool {
        let cl = (circle1.origin - circle2.origin).length.real
        let sr = circle1.radius + circle2.radius
        return cl <= sr
    }
    
    static func find(_ circle1: Circle< Value >, _ circle2: Circle< Value >) -> CircleToCircle {
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
                let v = Point(x: cmc.y, y: -cmc.x)
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

public extension Circle {
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Intersection2< Value >.CircleToCircle {
        return Intersection2.find(self, other)
    }
    
}
