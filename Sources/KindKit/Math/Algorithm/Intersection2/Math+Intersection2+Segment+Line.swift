//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
            
    @inlinable
    public static func possibly(_ circle: Segment2, _ line: Line2) -> Bool {
        return Self.possibly(line, circle)
    }
    
    @inlinable
    public static func find(_ circle: Segment2, _ line: Line2) -> LineToSegment {
        return Self.find(line, circle)
    }
    
}

public extension Segment2 {
    
    @inlinable
    func isIntersects(_ other: Line2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Line2) -> Math.Intersection2.LineToSegment {
        return Math.Intersection2.find(self, other)
    }
    
}
