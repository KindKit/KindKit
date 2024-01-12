//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PolylineToSegment : Equatable {
        
        public let polyline: PointIntoPolylineEdge
        public let segment: PointIntoLine
        public let squaredDistance: Distance.Squared
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ polyline: Polyline2, _ segment: Segment2) -> PolylineToSegment? {
        guard polyline.isEmpty == false else { return nil }
        var info: [PolylineToSegment] = []
        for edge in polyline.edgeIndecies {
            let f = Self.find(polyline[segment: edge], segment)
            info.append(.init(
                polyline: .init(
                    edge: edge,
                    closest: f.segment1.closest,
                    point: f.segment1.point
                ),
                segment: f.segment2,
                squaredDistance: f.squaredDistance
            ))
        }
        return info.min(by: {
            $0.squaredDistance < $1.squaredDistance
        })
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Math.Distance2.PolylineToSegment? {
        return Math.Distance2.find(self, other)
    }
    
}
