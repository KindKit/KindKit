//
//  KindKit
//
//
#if os(iOS)

import UIKit
import KindNumeric

public extension Rect {
    
    @inlinable
    func inset(_ value: UIEdgeInsets) -> Self {
        return self.inset(.init(value))
    }
    
}

#endif
