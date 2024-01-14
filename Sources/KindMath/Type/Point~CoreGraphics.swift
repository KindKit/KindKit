//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Point {
    
    @inlinable
    var cgPoint: CGPoint {
        return CGPoint(
            x: CGFloat(self.x),
            y: CGFloat(self.y)
        )
    }
    
    init(_ cgPoint: CGPoint) {
        self.x = Double(cgPoint.x)
        self.y = Double(cgPoint.y)
    }
    
}

#endif
