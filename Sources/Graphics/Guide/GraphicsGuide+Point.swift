//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsGuide {

    class Point {
        
        public var points: [PointFloat]
        public var snap: Float
        
        public init(
            points: [PointFloat],
            snap: Float
        ) {
            self.points = points
            self.snap = snap
        }

    }
    
}

extension GraphicsGuide.Point : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: PointFloat) -> PointFloat? {
        let snap = DistanceFloat(real: self.snap)
        let items = self.points.compactMap({ (
            point: $0,
            distance: $0.distance(coordinate)
        ) }).filter({
            $0.distance.abs >= snap
        })
        if let item = items.min(by: { $0.distance < $1.distance }) {
            return item.point
        }
        return nil
    }
    
}
