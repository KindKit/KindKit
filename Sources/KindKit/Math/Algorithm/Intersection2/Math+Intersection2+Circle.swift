//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public enum CircleToCircle : Equatable {
        
        case none
        case identical
        case one(Point)
        case two(Point, Point)
        
        @inlinable
        public var point1: Point? {
            switch self {
            case .one(let point): return point
            case .two(let point, _): return point
            default: return nil
            }
        }
        
        @inlinable
        public var point2: Point? {
            switch self {
            case .two(_, let point): return point
            default: return nil
            }
        }
        
    }
    
    @inlinable
    public static func possibly(_ circle1: Circle, _ circle2: Circle) -> Bool {
        let cl = (circle1.origin - circle2.origin).length.value
        let sr = (circle1.radius + circle2.radius).value
        return cl <= sr
    }
    
    public static func find(_ circle1: Circle, _ circle2: Circle) -> CircleToCircle {
        let cmc = circle2.origin - circle1.origin
        let rmr = circle1.radius - circle2.radius
        let cdot = cmc.dot(cmc)
        if cdot ~~ .zero && rmr ~~ .zero {
            return .identical
        }
        let rmrqr = rmr.squared
        if cdot < rmrqr.value {
            return .none
        }
        let rpr = circle1.radius + circle2.radius
        let rprqr = rpr.squared
        if cdot > rprqr.value {
            return .none
        }
        if cdot < rprqr.value {
            if rmrqr.value < cdot {
                let icdot = 1 / cdot
                let s = 0.5 * ((circle1.radius * circle1.radius - circle2.radius * circle2.radius).value * icdot + 1)
                let tmp = circle1.origin + s * cmc
                var d = (circle1.radius * circle2.radius).value * icdot - s * s
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
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Math.Intersection2.CircleToCircle {
        return Math.Intersection2.find(self, other)
    }
    
}
