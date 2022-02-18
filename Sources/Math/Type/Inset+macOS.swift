//
//  KindKitMath
//

#if os(macOS)

import AppKit

public extension Inset {
    
    @inlinable
    var nsEdgeInsets: NSEdgeInsets {
        return NSEdgeInsets(
            top: CGFloat(self.top),
            left: CGFloat(self.left),
            bottom: CGFloat(self.bottom),
            right: CGFloat(self.right)
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
