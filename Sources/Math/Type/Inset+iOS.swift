//
//  KindKitMath
//

#if os(iOS)

import UIKit

public extension Inset {
    
    @inlinable
    var uiEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: self.top.cgFloat,
            left: self.left.cgFloat,
            bottom: self.bottom.cgFloat,
            right: self.right.cgFloat
        )
    }
    
    @inlinable
    init(_ uiEdgeInsets: UIEdgeInsets) {
        self.top = Value(uiEdgeInsets.top)
        self.left = Value(uiEdgeInsets.left)
        self.right = Value(uiEdgeInsets.right)
        self.bottom = Value(uiEdgeInsets.bottom)
    }
    
}

#endif
