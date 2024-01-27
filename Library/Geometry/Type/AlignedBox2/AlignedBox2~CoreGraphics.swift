//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindNumeric

public extension AlignedBox2 {
    
    @inlinable
    init(_ cgRect: CGRect) {
        self.init(
            lower: .init(x: .init(cgRect.minX), y: .init(cgRect.minY)),
            upper: .init(x: .init(cgRect.maxX), y: .init(cgRect.maxY))
        )
    }
    
    @inlinable
    init(origin: CGPoint, size: CGSize) {
        self.init(CGRect(origin: origin, size: size))
    }
    
}

public extension AlignedBox2 {
    
    @inlinable
    var cgRect: CGRect {
        return .init(
            origin: self.topLeft.cgPoint,
            size: self.size.cgSize
        )
    }
    
}

#endif
