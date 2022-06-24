//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Point {
    
    @inlinable
    var cgPoint: CGPoint {
        return CGPoint(
            x: self.x.cgFloat,
            y: self.y.cgFloat
        )
    }
    
    @inlinable
    init(_ cgPoint: CGPoint) {
        self.x = Value(cgPoint.x)
        self.y = Value(cgPoint.y)
    }
    
}

#endif
