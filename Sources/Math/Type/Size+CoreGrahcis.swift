//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Size {
    
    @inlinable
    var cgSize: CGSize {
        return CGSize(
            width: self.width.cgFloat,
            height: self.height.cgFloat
        )
    }
    
    @inlinable
    init(_ cgSize: CGSize) {
        self.width = Value(cgSize.width)
        self.height = Value(cgSize.height)
    }
    
}

#endif
