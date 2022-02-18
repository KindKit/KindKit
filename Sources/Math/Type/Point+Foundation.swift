//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Point {
    
    @inlinable
    var cgPoint: CGPoint {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    
    @inlinable
    init(_ cgPoint: CGPoint) {
        self.x = ValueType(cgPoint.x)
        self.y = ValueType(cgPoint.y)
    }
    
}

#endif
