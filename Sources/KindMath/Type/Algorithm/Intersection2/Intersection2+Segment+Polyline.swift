//
//  KindKit
//

import Foundation

extension Intersection2 {
    
    public typealias SegmentToPolyline = PolylineToSegment
            
    @inlinable
    public static func possibly(_ segment: Segment2, _ polyline: Polyline2) -> Bool {
        return Self.possibly(polyline, segment)
    }
    
    @inlinable
    public static func find(_ segment: Segment2, _ polyline: Polyline2) -> SegmentToPolyline? {
        return Self.find(polyline, segment)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func isIntersects(_ other: Polyline2) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Polyline2) -> Intersection2.SegmentToPolyline? {
        return Intersection2.find(self, other)
    }
    
}
