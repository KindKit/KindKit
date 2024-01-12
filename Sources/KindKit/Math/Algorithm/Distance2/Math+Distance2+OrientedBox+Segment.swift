//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public typealias OrientedBoxToSegment = SegmentToOrientedBox
    
    @inlinable
    public static func find(_ box: OrientedBox2, _ segment: Segment2) -> OrientedBoxToSegment {
        return Self.find(segment, box)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.OrientedBoxToSegment {
        return Math.Distance2.find(other, self)
    }
    
}
