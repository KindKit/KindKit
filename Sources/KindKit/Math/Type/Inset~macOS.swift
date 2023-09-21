//
//  KindKit
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
    
    init(_ nsEdgeInsets: NSEdgeInsets) {
        self.top = Double(nsEdgeInsets.top)
        self.left = Double(nsEdgeInsets.left)
        self.right = Double(nsEdgeInsets.right)
        self.bottom = Double(nsEdgeInsets.bottom)
    }
    
}

#endif
