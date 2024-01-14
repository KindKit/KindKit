//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public typealias SegmentToPolyline = PolylineToSegment
    
    @inlinable
    public static func find(_ segment: Segment2, _ polyline: Polyline2) -> SegmentToPolyline? {
        return Self.find(polyline, segment)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: Polyline2) -> Distance2.SegmentToPolyline? {
        return Distance2.find(self, other)
    }
    
}
