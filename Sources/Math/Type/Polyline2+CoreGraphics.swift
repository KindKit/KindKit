//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Polyline2 {
    
    @inlinable
    var cgPath: CGPath {
        let cgPath = CGMutablePath()
        if self.corners.count > 1 {
            cgPath.move(to: self.corners[0].cgPoint)
            for point in self.corners[1 ..< self.corners.endIndex] {
                cgPath.addLine(to: point.cgPoint)
            }
            cgPath.closeSubpath()
        }
        return cgPath
    }
    
}

#endif
