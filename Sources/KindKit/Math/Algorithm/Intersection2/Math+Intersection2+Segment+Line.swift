//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public typealias SegmentToLine = LineToSegment
            
    @inlinable
    public static func possibly(_ circle: Segment2, _ line: Line2) -> Bool {
        return Self.possibly(line, circle)
    }
    
    @inlinable
    public static func find(_ circle: Segment2, _ line: Line2) -> SegmentToLine? {
        return Self.find(line, circle)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func isIntersects(_ other: Line2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Line2) -> Math.Intersection2.SegmentToLine? {
        return Math.Intersection2.find(self, other)
    }
    
}
