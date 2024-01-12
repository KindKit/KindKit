//
//  KindKit
//

import Foundation

extension Math.Intersection2 {
    
    public struct PolylineToSegment : Equatable {
        
        public let edge: Polyline2.EdgeIndex
        public let info: Math.Intersection2.SegmentToSegment
        
        public init(
            edge: Polyline2.EdgeIndex,
            info: Math.Intersection2.SegmentToSegment
        ) {
            self.edge = edge
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
        
    public static func possibly(_ polyline: Polyline2, _ segment: Segment2) -> Bool {
        guard polyline.isEmpty == false else { return false }
        for ps in polyline.segments {
            if Self.possibly(ps, segment) == true {
                return true
            }
        }
        return false
    }
    
    public static func find(_ polyline: Polyline2, _ segment: Segment2) -> PolylineToSegment? {
        guard polyline.isEmpty == false else { return nil }
        for edgeIndex in 0 ..< polyline.edges.count {
            let ps = polyline[segment: .init(edgeIndex)]
            guard let intersection = Self.find(ps, segment) else { continue }
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
    func isIntersects(_ other: Segment2) -> Bool {
        return Math.Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Segment2) -> Math.Intersection2.PolylineToSegment? {
        return Math.Intersection2.find(self, other)
    }
    
}
