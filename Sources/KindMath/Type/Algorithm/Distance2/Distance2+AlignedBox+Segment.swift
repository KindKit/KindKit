//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public typealias AlignedBoxToSegment = SegmentToAlignedBox
    
    @inlinable
    public static func find(_ box: AlignedBox2, _ segment: Segment2) -> AlignedBoxToSegment {
        return Self.find(segment, box)
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Distance2.AlignedBoxToSegment {
        return Distance2.find(other, self)
    }
    
}
