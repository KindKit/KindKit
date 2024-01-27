//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindNumeric

public extension OrientedBox2 {
    
    @inlinable
    init(_ cgRect: CGRect, angle: Radian) {
        self.init(
            shape: .init(cgRect),
            angle: angle
        )
    }
    
    @inlinable
    init(origin: CGPoint, size: CGSize, angle: Radian) {
        self.init(
            shape: .init(CGRect(origin: origin, size: size)),
            angle: angle
        )
    }
    
}

#endif
