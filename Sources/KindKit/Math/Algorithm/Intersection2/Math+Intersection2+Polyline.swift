//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public struct PolylineToPolyline : Equatable {
        
        public let edge1: Polyline2.EdgeIndex
        public let edge2: Polyline2.EdgeIndex
        public let info: Math.Intersection2.SegmentToSegment
        
        public init(
            edge1: Polyline2.EdgeIndex,
            edge2: Polyline2.EdgeIndex,
            info: Math.Intersection2.SegmentToSegment
        ) {
            self.edge1 = edge1
            self.edge2 = edge2
            self.info = info
        }
        
        @inlinable
        public var point1: Point {
            switch self.info {
            case .point(let point): return point
            case .segment(let segment): return segment.start
            }
        }
        
        @inlinable
        public var point2: Point? {
            switch self.info {
            case .segment(let segment): return segment.end
            default: return nil
            }
        }
        
    }
        
    public static func possibly(_ polyline1: Polyline2, _ polyline2: Polyline2) -> Bool {
        guard polyline1.isEmpty == false && polyline2.isEmpty == false else { return false }
        guard polyline1.bbox.isIntersects(polyline2.bbox) == true else { return false }
        for segment in polyline1.segments {
            if Self.possibly(polyline2, segment) == true {
                return true
            }
        }
        return false
    }
    
    public static func find(_ polyline1: Polyline2, _ polyline2: Polyline2) -> PolylineToPolyline? {
        guard polyline1.isEmpty == false && polyline2.isEmpty == false else { return nil }
        guard polyline1.bbox.isIntersects(polyline2.bbox) == true else { return nil }
        for edgeIndex in 0 ..< polyline1.edges.count {
            let segment = polyline1[segment: .init(edgeIndex)]
            guard let intersection = Self.find(polyline2, segment) else { continue }
            return .init(
                edge1: .init(edgeIndex),
                edge2: intersection.edge,
                info: intersection.info
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
