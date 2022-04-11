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
        self.top = ValueType(nsEdgeInsets.top)
        self.left = ValueType(nsEdgeInsets.left)
        self.right = ValueType(nsEdgeInsets.right)
        self.bottom = ValueType(nsEdgeInsets.bottom)
    }
    
}

#endif
