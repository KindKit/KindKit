//
//  KindKit
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
    
    init(_ uiEdgeInsets: UIEdgeInsets) {
        self.top = Double(uiEdgeInsets.top)
        self.left = Double(uiEdgeInsets.left)
        self.right = Double(uiEdgeInsets.right)
        self.bottom = Double(uiEdgeInsets.bottom)
    }
    
}

#endif
