//
//  KindKit
//

import Foundation

public extension Intersection2 {
    
    enum LineToBox : Equatable {
        
        case none
        case one(Point)
        case two(Point, Point)
        
    }
    
}

public extension Intersection2 {
    
    static func possibly(_ line: Line2, _ box: Box2) -> Bool {
        let bcf = box.centeredForm
        let o = line.origin - bcf.center
        let lhs = line.direction.dot(o.perpendicular).abs
        let rhs = (bcf.extend.x * line.direction.x.abs) + (bcf.extend.y * line.direction.y.abs)
        return lhs <= rhs
    }
    
    static func find(_ line: Line2, _ box: Box2) -> LineToBox {
        let bcf = box.centeredForm
        let o = line.origin - bcf.center
        var t1 = Double(Int.min);
        var t2 = Double(Int.max);
        if Self.clip(line.direction.x, -o.x - bcf.extend.x, &t1, &t2) && Self.clip(-line.direction.x, o.x - bcf.extend.x, &t1, &t2) && Self.clip(line.direction.y, -o.y - bcf.extend.y, &t1, &t2) && Self.clip(-line.direction.y, o.y - bcf.extend.y, &t1, &t2) {
            if t2 > t1 {
                return .two(
                    line.origin + t1 * line.direction,
                    line.origin + t2 * line.direction
                )
            } else {
                return .one(
                    line.origin + t1 * line.direction
                )
            }
        }
        return .none
    }
    
}

fileprivate extension Intersection2 {
    
    static func clip(_ d: Double, _ n: Double, _ t1: inout Double, _ t2: inout Double) -> Bool {
        if d > 0 {
            if n > d * t2 {
                return false
            } else if n > d * t1 {
                t1 = n / d
            }
            return true
        } else if d < 0 {
            if n > d * t1 {
                return false
            } else if n > d * t2 {
                t2 = n / d
            }
            return true
        }
        return n <= 0
    }
    
}

public extension Line2 {
    
    @inlinable
    func isIntersects(_ other: Box2) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Box2) -> Intersection2.LineToBox {
        return Intersection2.find(self, other)
    }
    
}

public extension Box2 {
    
    @inlinable
    func isIntersects(_ other: Line2) -> Bool {
        return Intersection2.possibly(other, self)
    }
    
    @inlinable
    func intersection(_ other: Line2) -> Intersection2.LineToBox {
        return Intersection2.find(other, self)
    }
    
}
