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
        self.x = ValueType(cgPoint.x)
        self.y = ValueType(cgPoint.y)
    }
    
}

#endif
