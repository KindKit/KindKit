//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsGuide {

    class Lines : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var lines: [Line2Float]
        public var snap: Float
        
        public init(
            isEnabled: Bool = true,
            lines: [Line2Float],
            snap: Float
        ) {
            self.isEnabled = isEnabled
            self.lines = lines
            self.snap = snap
        }

    }
    
}

extension GraphicsGuide.Lines : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: PointFloat) -> PointFloat? {
        guard self.isEnabled == true else { return nil }
        let snap = DistanceFloat(real: self.snap)
        let oi = self.lines.compactMap({ ( line: $0, distance: $0.distance(coordinate) ) })
        let fi = oi.filter({ $0.distance.abs <= snap })
        let si = fi.sorted(by: { $0.distance < $1.distance })
        if let i = si.first {
            return i.line.perpendicular(coordinate)
        }
        return nil
    }
    
}
