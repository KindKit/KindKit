//
//  KindKitMath
//

#if os(iOS)

import UIKit

public extension Inset {
    
    @inlinable
    var uiEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: CGFloat(self.top),
            left: CGFloat(self.left),
            bottom: CGFloat(self.bottom),
            right: CGFloat(self.right)
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
