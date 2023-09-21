//
//  KindKit
//

#if os(macOS)

import AppKit

public extension Rect {
    
    @inlinable
    func inset(_ value: NSEdgeInsets) -> Self {
        return self.inset(Inset(value))
    }
    
}

#endif
