//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public typealias SegmentToPolyline = PolylineToSegment
    
    @inlinable
    public static func find(_ segment: Segment2, _ polyline: Polyline2) -> SegmentToPolyline? {
        return Self.find(polyline, segment)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func distance(_ other: Polyline2) -> Math.Distance2.SegmentToPolyline? {
        return Math.Distance2.find(self, other)
    }
    
}
