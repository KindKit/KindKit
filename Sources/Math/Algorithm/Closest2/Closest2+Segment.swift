//
//  KindKitMath
//

import Foundation

public extension Closest2 {
    
    @inlinable
    static func find(_ point: PointType, _ segment: SegmentType) -> Percent< ValueType > {
        let r = point - segment.start
        let d = segment.end - segment.start
        let p = r.dot(d) / d.dot(d)
        return Percent(p)
    }
    
}
