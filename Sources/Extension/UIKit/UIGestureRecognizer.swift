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

    func kk_update(cancelsTouchesInView: Bool) {
        self.cancelsTouchesInView = cancelsTouchesInView
    }

    func kk_update(delaysTouchesBegan: Bool) {
        self.delaysTouchesBegan = delaysTouchesBegan
    }

    func kk_update(delaysTouchesEnded: Bool) {
        self.delaysTouchesEnded = delaysTouchesEnded
    }

    func kk_update(requiresExclusiveTouchType: Bool) {
        self.requiresExclusiveTouchType = requiresExclusiveTouchType
    }

}

#endif
