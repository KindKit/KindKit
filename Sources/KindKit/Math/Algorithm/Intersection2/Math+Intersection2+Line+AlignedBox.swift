//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public enum LineToAlignedBox : Equatable {
        
        case one(Point)
        case two(Point, Point)
        
    }
        
    public static func possibly(_ line: Line2, _ box: AlignedBox2) -> Bool {
        let bcf = box.centeredForm
        let o = line.origin - bcf.center
        let lhs = line.direction.dot(o.perpendicular).abs
        let rhs = (bcf.extent.x * line.direction.x.abs) + (bcf.extent.y * line.direction.y.abs)
        return lhs <= rhs
    }
    
    public static func find(_ line: Line2, _ box: AlignedBox2) -> LineToAlignedBox? {
        let bcf = box.centeredForm
        let o = line.origin - bcf.center
        var t1 = Double(Int.min)
        var t2 = Double(Int.max)
        guard Self._clip(line.direction.x, -o.x - bcf.extent.x, &t1, &t2) == true else {
            return .none
        }
        guard Self._clip(-line.direction.x, o.x - bcf.extent.x, &t1, &t2) == true else {
            return .none
        }
        guard Self._clip(line.direction.y, -o.y - bcf.extent.y, &t1, &t2) == true else {
            return .none
        }
        guard Self._clip(-line.direction.y, o.y - bcf.extent.y, &t1, &t2) == true else {
            return .none
        }
        if t2 > t1 {
            return .two(
                line.origin + t1 * line.direction,
                line.origin + t2 * line.direction
            )
        }
        return .one(
            line.origin + t1 * line.direction
        )
    }
        
    fileprivate static func _clip(_ d: Double, _ n: Double, _ t1: inout Double, _ t2: inout Double) -> Bool {
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
    func isIntersects(_ other: AlignedBox2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: AlignedBox2) -> Math.Intersection2.LineToAlignedBox? {
        return Math.Intersection2.find(self, other)
    }
    
}
