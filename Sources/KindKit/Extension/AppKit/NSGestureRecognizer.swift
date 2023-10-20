//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeGesture = NSGestureRecognizer

public extension NSGestureRecognizer {
    
    func kk_update(enabled: Bool) {
        self.isEnabled = enabled
    }

}

#endif
