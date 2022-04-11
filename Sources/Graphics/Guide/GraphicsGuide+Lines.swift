//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsGuide {

    class Lines {
        
        public var lines: [Line2Float]
        public var snap: Float
        
        public init(
            lines: [Line2Float],
            snap: Float
        ) {
            self.lines = lines
            self.snap = snap
        }

    }
    
}

extension GraphicsGuide.Lines : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: PointFloat) -> PointFloat? {
        let snap = self.snap * self.snap
        let items = self.lines.compactMap({ (
            line: $0,
            distance: $0.distance(coordinate)
        ) }).filter({
            $0.distance.squared.abs >= snap
        })
        if let item = items.min(by: { $0.distance < $1.distance }) {
            let p = item.line.perpendicular(coordinate)
            return coordinate * p
        }
        return nil
    }
    
}
