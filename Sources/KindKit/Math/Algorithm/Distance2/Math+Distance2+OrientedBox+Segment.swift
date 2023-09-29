//
//  KindKit
//

import Foundation

extension Math.Distance2 {
            
    @inlinable
    public static func find(_ box: OrientedBox2, _ segment: Segment2) -> SegmentToOrientedBox {
        return Self.find(segment, box)
    }
    
}

public extension OrientedBox2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.SegmentToOrientedBox {
        return Math.Distance2.find(other, self)
    }
    
}
