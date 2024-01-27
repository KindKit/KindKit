//
//  KindKit
//

#if os(iOS)

import UIKit
import KindNumeric

public extension Inset {
    
    init(_ uiEdgeInsets: UIEdgeInsets) {
        self.top = .init(uiEdgeInsets.top)
        self.left = .init(uiEdgeInsets.left)
        self.right = .init(uiEdgeInsets.right)
        self.bottom = .init(uiEdgeInsets.bottom)
    }
    
}

public extension Inset {
    
    @inlinable
    var uiEdgeInsets: UIEdgeInsets {
        return .init(
            top: self.top.cgFloat,
            left: self.left.cgFloat,
            bottom: self.bottom.cgFloat,
            right: self.right.cgFloat
        )
    }
    
}

#endif
