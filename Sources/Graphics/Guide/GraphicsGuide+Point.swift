//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsGuide {

    class Point : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var points: [PointFloat]
        public var snap: Float
        
        public init(
            isEnabled: Bool = true,
            points: [PointFloat],
            snap: Float
        ) {
            self.isEnabled = isEnabled
            self.points = points
            self.snap = snap
        }

    }
    
}

extension GraphicsGuide.Point : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: PointFloat) -> PointFloat? {
        guard self.isEnabled == true else { return nil }
        let snap = DistanceFloat(real: self.snap)
        let oi = self.points.compactMap({ ( point: $0, distance: $0.distance(coordinate) ) })
        let fi = oi.filter({ $0.distance.abs <= snap })
        let si = fi.sorted(by: { $0.distance < $1.distance })
        if let i = si.first {
            return i.point
        }
        return nil
    }
    
}
