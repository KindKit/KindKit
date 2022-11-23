//
//  KindKit
//

import Foundation

public extension Graphics.Guide {

    final class Point : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var points: [KindKit.Point]
        public var snap: Double
        
        public init(
            isEnabled: Bool = true,
            points: [KindKit.Point],
            snap: Double
        ) {
            self.isEnabled = isEnabled
            self.points = points
            self.snap = snap
        }

    }
    
}

extension Graphics.Guide.Point : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: KindKit.Point) -> KindKit.Point? {
        guard self.isEnabled == true else { return nil }
        let snap = Distance(real: self.snap)
        let oi = self.points.map({ (point: $0, distance: $0.distance(coordinate)) })
        let fi = oi.filter({ $0.distance.abs <= snap })
        let si = fi.sorted(by: { $0.distance < $1.distance })
        if let i = si.first {
            return i.point
        }
        return nil
    }
    
}
