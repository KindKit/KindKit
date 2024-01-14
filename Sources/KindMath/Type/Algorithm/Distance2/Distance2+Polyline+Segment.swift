//
//  KindKit
//

import Foundation

extension Distance2 {
    
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
        var result: PolylineToSegment?
        for edge in polyline.edgeIndecies {
            let f = Self.find(polyline[segment: edge], segment)
            if let last = result {
                if f.squaredDistance < last.squaredDistance {
                    result = .init(
                        polyline: .init(
                            edge: edge,
                            closest: f.segment1.closest,
                            point: f.segment1.point
                        ),
                        segment: f.segment2,
                        squaredDistance: f.squaredDistance
                    )
                }
            } else {
                result = .init(
                    polyline: .init(
                        edge: edge,
                        closest: f.segment1.closest,
                        point: f.segment1.point
                    ),
                    segment: f.segment2,
                    squaredDistance: f.squaredDistance
                )
            }
        }
        return result
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func distance(_ other: Segment2) -> Distance2.PolylineToSegment? {
        return Distance2.find(self, other)
    }
    
}
