//
//  KindKit
//

#if os(macOS)

import AppKit
import KindNumeric

public extension Inset {
    
    init(_ nsEdgeInsets: NSEdgeInsets) {
        self.top = .init(nsEdgeInsets.top)
        self.left = .init(nsEdgeInsets.left)
        self.right = .init(nsEdgeInsets.right)
        self.bottom = .init(nsEdgeInsets.bottom)
    }
    
}

public extension Inset {
    
    @inlinable
    var nsEdgeInsets: NSEdgeInsets {
        return .init(
            top: self.top.cgFloat,
            left: self.left.cgFloat,
            bottom: self.bottom.cgFloat,
            right: self.right.cgFloat
        )
    }
    
}

#endif
