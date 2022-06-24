//
//  KindKitMath
//

#if os(macOS)

import AppKit

public extension Inset {
    
    @inlinable
    var nsEdgeInsets: NSEdgeInsets {
        return NSEdgeInsets(
            top: self.top.cgFloat,
            left: self.left.cgFloat,
            bottom: self.bottom.cgFloat,
            right: self.right.cgFloat
        )
    }
    
    @inlinable
    init(_ nsEdgeInsets: NSEdgeInsets) {
        self.top = Value(nsEdgeInsets.top)
        self.left = Value(nsEdgeInsets.left)
        self.right = Value(nsEdgeInsets.right)
        self.bottom = Value(nsEdgeInsets.bottom)
    }
    
}

#endif
