//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeGesture = UIGestureRecognizer

public extension UIGestureRecognizer {
    
    func update(enabled: Bool) {
        self.isEnabled = enabled
    }

    func update(cancelsTouchesInView: Bool) {
        self.cancelsTouchesInView = cancelsTouchesInView
    }

    func update(delaysTouchesBegan: Bool) {
        self.delaysTouchesBegan = delaysTouchesBegan
    }

    func update(delaysTouchesEnded: Bool) {
        self.delaysTouchesEnded = delaysTouchesEnded
    }

    func update(requiresExclusiveTouchType: Bool) {
        self.requiresExclusiveTouchType = requiresExclusiveTouchType
    }

}

#endif
