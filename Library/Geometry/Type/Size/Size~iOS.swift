//
//  KindKit
//

#if os(iOS)

import UIKit
import KindNumeric

public extension Size {
    
    @inlinable
    func inset(_ value: UIEdgeInsets) -> Self {
        return self.inset(
            horizontal: .init(value.left + value.right),
            vertical: .init(value.top + value.bottom)
        )
    }
    
}

#endif
