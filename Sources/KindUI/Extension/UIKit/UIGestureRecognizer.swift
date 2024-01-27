//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeGesture = UIGestureRecognizer

public extension UIGestureRecognizer {
    
    func kk_update(enabled: Bool) {
        self.isEnabled = enabled
    }

    func kk_update(cancelsInView: Bool) {
        self.cancelsTouchesInView = cancelsInView
    }

    func kk_update(delaysBegan: Bool) {
        self.delaysTouchesBegan = delaysBegan
    }

    func kk_update(delaysEnded: Bool) {
        self.delaysTouchesEnded = delaysEnded
    }

    func kk_update(requiresExclusive: Bool) {
        self.requiresExclusiveTouchType = requiresExclusive
    }

}

#endif
