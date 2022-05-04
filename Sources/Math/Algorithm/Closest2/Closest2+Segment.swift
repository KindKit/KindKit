//
//  KindKitMath
//

import Foundation

public extension Closest2 {
    
    @inlinable
    static func find(_ point: PointType, _ segment: SegmentType) -> Percent< ValueType > {
        let r = point - segment.start
        let d = segment.end - segment.start
        let p = Percent(r.dot(d) / d.dot(d))
        return p.normalized
    }
    
}

public extension Segment2 {
    
    @inlinable
    func closest(_ point: Point< ValueType >) -> Percent< ValueType > {
        return Closest2.find(point, self)
    }
    
}
