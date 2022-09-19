//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeGesture = NSGestureRecognizer

public extension NSGestureRecognizer {
    
    func update(enabled: Bool) {
        self.isEnabled = enabled
    }

    func update(delaysPrimaryMouseButtonEvents: Bool) {
        self.delaysPrimaryMouseButtonEvents = delaysPrimaryMouseButtonEvents
    }

    func update(delaysSecondaryMouseButtonEvents: Bool) {
        self.delaysSecondaryMouseButtonEvents = delaysSecondaryMouseButtonEvents
    }

    func update(delaysOtherMouseButtonEvents: Bool) {
        self.delaysOtherMouseButtonEvents = delaysOtherMouseButtonEvents
    }

    func update(delaysKeyEvents: Bool) {
        self.delaysKeyEvents = delaysKeyEvents
    }

    func update(delaysMagnificationEvents: Bool) {
        self.delaysMagnificationEvents = delaysMagnificationEvents
    }
    
    func update(delaysRotationEvents: Bool) {
        self.delaysRotationEvents = delaysRotationEvents
    }

}

#endif
