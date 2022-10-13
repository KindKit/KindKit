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

    func kk_update(delaysPrimaryMouseButtonEvents: Bool) {
        self.delaysPrimaryMouseButtonEvents = delaysPrimaryMouseButtonEvents
    }

    func kk_update(delaysSecondaryMouseButtonEvents: Bool) {
        self.delaysSecondaryMouseButtonEvents = delaysSecondaryMouseButtonEvents
    }

    func kk_update(delaysOtherMouseButtonEvents: Bool) {
        self.delaysOtherMouseButtonEvents = delaysOtherMouseButtonEvents
    }

    func kk_update(delaysKeyEvents: Bool) {
        self.delaysKeyEvents = delaysKeyEvents
    }

    func kk_update(delaysMagnificationEvents: Bool) {
        self.delaysMagnificationEvents = delaysMagnificationEvents
    }
    
    func kk_update(delaysRotationEvents: Bool) {
        self.delaysRotationEvents = delaysRotationEvents
    }

}

#endif
