//
//  KindKit
//

import Foundation

public extension Closest2 {
    
    @inlinable
    static func find(_ point: Point< Value >, _ segment: Segment2< Value >) -> Percent< Value > {
        let r = point - segment.start
        let d = segment.end - segment.start
        let p = Percent(r.dot(d) / d.dot(d))
        return p.normalized
    }
    
}

public extension Segment2 {
    
    @inlinable
    func closest(_ point: Point< Value >) -> Percent< Value > {
        return Closest2.find(point, self)
    }
    
}
