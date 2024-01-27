//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindNumeric

public extension Rect {
    
    init(_ cgRect: CGRect) {
        self.origin = .init(cgRect.origin)
        self.size = .init(cgRect.size)
    }
    
    init(cgOrigin: CGPoint, cgSize: CGSize) {
        self.origin = .init(cgOrigin)
        self.size = .init(cgSize)
    }
    
}

public extension Rect {
    
    @inlinable
    var cgRect: CGRect {
        return .init(
            origin: self.origin.cgPoint,
            size: self.size.cgSize
        )
    }
    
}

#endif
