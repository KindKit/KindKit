//
//  KindKit
//

#if os(macOS)

import AppKit
import KindNumeric

public extension Size {
    
    @inlinable
    func inset(_ value: NSEdgeInsets) -> Self {
        return self.inset(
            horizontal: .init(value.left + value.right),
            vertical: .init(value.top + value.bottom)
        )
    }
    
}

#endif
