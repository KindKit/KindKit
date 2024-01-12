//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public typealias AlignedBoxToSegment = SegmentToAlignedBox
        
    @inlinable
    public static func find(_ box: AlignedBox2, _ segment: Segment2) -> AlignedBoxToSegment {
        return Self.find(segment, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.AlignedBoxToSegment {
        return Math.Distance2.find(other, self)
    }
    
}
