//
//  KindKit
//

import Foundation

public extension Graphics.Guide {

    final class Lines : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var lines: [Line2]
        public var snap: Double
        
        public init(
            isEnabled: Bool = true,
            lines: [Line2],
            snap: Double
        ) {
            self.isEnabled = isEnabled
            self.lines = lines
            self.snap = snap
        }

    }
    
}

extension Graphics.Guide.Lines : IGraphicsCoordinateGuide {
    
    public func guide(_ coordinate: Point) -> Point? {
        guard self.isEnabled == true else { return nil }
        let snap = Distance(real: self.snap)
        let oi = self.lines.map({ (line: $0, distance: $0.distance(coordinate)) })
        let fi = oi.filter({ $0.distance.abs <= snap })
        let si = fi.sorted(by: { $0.distance < $1.distance })
        if let i = si.first {
            return i.line.perpendicular(coordinate)
        }
        return nil
    }
    
}
