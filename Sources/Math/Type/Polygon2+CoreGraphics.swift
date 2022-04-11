//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Polygon2 {
    
    @inlinable
    var cgPath: CGPath {
        let cgPath = CGMutablePath()
        for countour in self.countours {
            cgPath.addPath(countour.cgPath)
        }
        return cgPath
    }
    
}

#endif
