//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindNumeric

public extension Point {
    
    @inlinable
    init(_ cgPoint: CGPoint) {
        self.init(
            x: .init(cgPoint.x),
            y: .init(cgPoint.y)
        )
    }
    
}

public extension Point {
    
    @inlinable
    var cgPoint: CGPoint {
        return .init(
            x: self.x.cgFloat,
            y: self.y.cgFloat
        )
    }
    
}

#endif
