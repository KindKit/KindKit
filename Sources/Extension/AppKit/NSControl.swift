//
//  KindKit
//

#if os(macOS)

import AppKit

public extension NSControl {
    
    func update(locked: Bool) {
        self.isEnabled = locked == false
    }
    
}

#endif
