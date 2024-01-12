//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public struct PolylineToPolyline : Equatable {
        
        public let edge: Polyline2.EdgeIndex
        public let info: Math.Intersection2.PolylineToSegment
        
        public init(
            edge: Polyline2.EdgeIndex,
            info: Math.Intersection2.PolylineToSegment
        ) {
            self.edge = edge
            self.info = info
        }
        
    }
        
    public static func possibly(_ polyline1: Polyline2, _ polyline2: Polyline2) -> Bool {
        guard polyline1.isEmpty == false && polyline2.isEmpty == false else { return false }
        for segment in polyline1.segments {
            if Self.possibly(segment, polyline2) == true {
                return true
            }
        }
        return false
    }
    
    public static func find(_ polyline1: Polyline2, _ polyline2: Polyline2) -> PolylineToPolyline? {
        guard polyline1.isEmpty == false && polyline2.isEmpty == false else { return nil }
        for edgeIndex in 0 ..< polyline1.edges.count {
            guard let intersection = Self.find(polyline1[segment: .init(edgeIndex)], polyline2) else { continue }
            return .init(
                edge: .init(edgeIndex),
                info: intersection
            )
        }
        return nil
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func isIntersects(_ other: Polyline2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Polyline2) -> Math.Intersection2.PolylineToPolyline? {
        return Math.Intersection2.find(self, other)
    }
    
}
