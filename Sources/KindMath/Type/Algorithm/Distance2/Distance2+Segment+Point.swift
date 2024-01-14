//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public typealias SegmentToPoint = PointToSegment
    
    @inlinable
    public static func find(_ segment: Segment2, _ point: Point) -> SegmentToPoint {
        return Self.find(point, segment)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: Point) -> Distance2.PointToSegment {
        return Distance2.find(other, self)
    }
    
}
