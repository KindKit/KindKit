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
        self.top = ValueType(uiEdgeInsets.top)
        self.left = ValueType(uiEdgeInsets.left)
        self.right = ValueType(uiEdgeInsets.right)
        self.bottom = ValueType(uiEdgeInsets.bottom)
    }
    
}

#endif
