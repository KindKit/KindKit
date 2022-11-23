//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Size {
    
    @inlinable
    var cgSize: CGSize {
        return CGSize(
            width: CGFloat(self.width),
            height: CGFloat(self.height)
        )
    }
    
    init(_ cgSize: CGSize) {
        self.width = Double(cgSize.width)
        self.height = Double(cgSize.height)
    }
    
}

#endif
