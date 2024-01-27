//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindNumeric

public extension Size {
    
    init(_ cgSize: CGSize) {
        self.width = .init(cgSize.width)
        self.height = .init(cgSize.height)
    }
    
}

public extension Size {
    
    @inlinable
    var cgSize: CGSize {
        return .init(
            width: self.width.cgFloat,
            height: self.height.cgFloat
        )
    }
    
}

#endif
