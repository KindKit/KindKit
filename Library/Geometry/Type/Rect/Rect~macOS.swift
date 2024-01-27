//
//  KindKit
//

#if os(macOS)

import AppKit
import KindNumeric

public extension Rect {
    
    @inlinable
    func inset(_ value: NSEdgeInsets) -> Self {
        return self.inset(.init(value))
    }
    
}

#endif
