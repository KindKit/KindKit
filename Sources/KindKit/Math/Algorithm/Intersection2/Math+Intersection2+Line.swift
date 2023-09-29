//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public enum LineToLine : Equatable {
        
        case none
        case parallel
        case point(Location)
        
        public struct Location : Equatable {
            
            public let parameter1: Double
            public let parameter2: Double
            public let point: Point
            
        }
        
    }
    
    public static func possibly(_ line1: Line2, _ line2: Line2) -> Bool {
        let od = line2.origin - line1.origin
        let dp = line1.direction.dot(line2.direction.perpendicular)
        if dp ~~ 0 {
            let nod = od.normalized.point
            let dpnod = nod.dot(line2.direction.perpendicular)
            if dpnod !~ 0 {
                return false
            }
        }
        return true
    }
    
    public static func find(_ line1: Line2, _ line2: Line2) -> LineToLine {
        let od = line2.origin - line1.origin
        let dp = line1.direction.dot(line2.direction.perpendicular)
        if dp !~ 0 {
            let oddp1 = od.dot(line1.direction.perpendicular)
            let oddp2 = od.dot(line2.direction.perpendicular)
            let s1 = oddp2 / dp
            let s2 = oddp1 / dp
            return .point(.init(
                parameter1: s1,
                parameter2: s2,
                point: line1.origin + s1 * line1.direction
            ))
        }
        let oddp = od.dot(line2.direction.perpendicular)
        if oddp.abs ~~ 0 {
            return .parallel
        }
        return .none
    }
    
}

public extension Line2 {
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Math.Intersection2.LineToLine {
        return Math.Intersection2.find(self, other)
    }
    
}
