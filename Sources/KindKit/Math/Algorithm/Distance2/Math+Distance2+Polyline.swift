//
//  KindKit
//

import Foundation

extension Math.Distance2 {
    
    public struct PolylineToPolyline : Equatable {
        
        public let edges: [Edge]
        
        public struct Edge : Equatable {
            
            public let polyline1: PointIntoPolylineEdge
            public let polyline2: PointIntoPolylineEdge
            public let squaredDistance: Distance.Squared
            
            @inlinable
            public var distance: Distance {
                return self.squaredDistance.normal
            }
            
        }
        
    }
    
    public static func find(_ polyline1: Polyline2, _ polyline2: Polyline2) -> PolylineToPolyline {
        var edges: [PolylineToPolyline.Edge] = []
        for edge1 in polyline1.edgeIndecies {
            guard let f = Self.find(polyline1[segment: edge1], polyline2) else { continue }
            edges.append(.init(
                polyline1: .init(
                    edge: edge1,
                    closest: f.segment.closest,
                    point: f.segment.point
                ),
                polyline2: f.polyline,
                squaredDistance: f.squaredDistance
            ))
        }
        return .init(edges: edges)
    }
    
}

public extension Polyline2 {
    
    @inlinable
    func distance(_ other: Polyline2) -> Math.Distance2.PolylineToPolyline {
        return Math.Distance2.find(self, other)
    }
    
}
