//
//  KindKit
//

import Foundation

extension Math.Distance2 {
        
    @inlinable
    public static func find(_ box: AlignedBox2, _ segment: Segment2) -> SegmentToAlignedBox {
        return Self.find(segment, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.SegmentToAlignedBox {
        return Math.Distance2.find(other, self)
    }
    
}
