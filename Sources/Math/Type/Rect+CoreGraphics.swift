//
//  KindKitMath
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
    
    @inlinable
    init(_ cgRect: CGRect) {
        self.origin = Point(cgRect.origin)
        self.size = Size(cgRect.size)
    }
    
}

#endif
