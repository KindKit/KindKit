//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum LineToLine : Equatable {
        case none
        case parallel
        case point(Location)
    }
    
}

public extension Intersection2.LineToLine {
    
    struct Location : Equatable {
        
        public let range: Intersection2.RangeType
        public let point: Intersection2.PointType
        
    }
    
}

public extension Intersection2 {
    
    static func possibly(_ line1: LineType, _ line2: LineType) -> Bool {
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
    
    static func find(_ line1: LineType, _ line2: LineType) -> LineToLine {
        let od = line2.origin - line1.origin
        let dp = line1.direction.dot(line2.direction.perpendicular)
        if dp !~ 0 {
            let oddp1 = od.dot(line1.direction.perpendicular)
            let oddp2 = od.dot(line2.direction.perpendicular)
            let s1 = oddp2 / dp
            let s2 = oddp1 / dp
            return .point(.init(
                range: RangeType(lower: s1, upper: s2),
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
