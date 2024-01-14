//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Rect {
    
    @inlinable
    var cgRect: CGRect {
        return CGRect(
            origin: self.origin.cgPoint,
            size: self.size.cgSize
        )
    }
    
    init(_ cgRect: CGRect) {
        self.origin = .init(cgRect.origin)
        self.size = .init(cgRect.size)
    }
    
    init(origin: CGPoint, size: CGSize) {
        self.origin = .init(origin)
        self.size = .init(size)
    }
    
}

#endif
