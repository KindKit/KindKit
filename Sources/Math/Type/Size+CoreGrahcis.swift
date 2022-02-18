//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Size {
    
    @inlinable
    var cgSize: CGSize {
        return CGSize(width: CGFloat(self.width), height: CGFloat(self.height))
    }
    
    @inlinable
    init(_ cgSize: CGSize) {
        self.width = ValueType(cgSize.width)
        self.height = ValueType(cgSize.height)
    }
    
}

#endif
