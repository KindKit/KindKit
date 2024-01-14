//
//  KindKit
//

import Foundation

extension Distance2 {
    
    public struct PolylineToPolyline : Equatable {
        
        public let polyline1: PointIntoPolylineEdge
        public let polyline2: PointIntoPolylineEdge
        public let squaredDistance: Distance.Squared
        
        @inlinable
        public var distance: Distance {
            return self.squaredDistance.normal
        }
        
    }
    
    public static func find(_ polyline1: Polyline2, _ polyline2: Polyline2) -> PolylineToPolyline? {
        guard polyline1.isEmpty == false else { return nil }
        var result: PolylineToPolyline?
        for edge in polyline1.edgeIndecies {
            guard let f = Self.find(polyline2, polyline1[segment: edge]) else { continue }
            if let last = result {
                if f.squaredDistance < last.squaredDistance {
                    result = .init(
                        polyline1: .init(
                            edge: edge,
                            closest: f.segment.closest,
                            point: f.segment.point
                        ),
                        polyline2: f.polyline,
                        squaredDistance: f.squaredDistance
                    )
                }
            } else {
                result = .init(
                    polyline1: .init(
                        edge: edge,
                        closest: f.segment.closest,
                        point: f.segment.point
                    ),
                    polyline2: f.polyline,
                    squaredDistance: f.squaredDistance
                )
            }
        }
        return result
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func distance(_ other: Polyline2) -> Distance2.PolylineToPolyline? {
        return Distance2.find(self, other)
    }
    
}
