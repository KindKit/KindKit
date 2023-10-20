//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.Gesture.LongTap {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.Gesture.LongTap
        typealias Content = KKLongTapGesture

        static var reuseIdentificator: String {
            return "UI.Gesture.LongTap"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content()
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.kk_update(gesture: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKLongTapGesture : UILongPressGestureRecognizer {
    
    weak var kkDelegate: KKTapGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }
    
}

extension KKLongTapGesture {
    
    func kk_update(gesture: UI.Gesture.LongTap) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(cancelsTouchesInView: gesture.cancelsTouchesInView)
        self.kk_update(delaysTouchesBegan: gesture.delaysTouchesBegan)
        self.kk_update(delaysTouchesEnded: gesture.delaysTouchesEnded)
        self.kk_update(requiresExclusiveTouchType: gesture.requiresExclusiveTouchType)
        self.kk_update(numberOfTapsRequired: gesture.numberOfTapsRequired)
        self.kk_update(numberOfTouchesRequired: gesture.numberOfTouchesRequired)
        self.kk_update(minimumDuration: gesture.minimumDuration)
        self.kk_update(allowableMovement: gesture.allowableMovement)
        self.kkDelegate = gesture
    }
    
    func kk_update(numberOfTapsRequired: UInt) {
        self.numberOfTapsRequired = Int(numberOfTapsRequired)
    }
    
    func kk_update(numberOfTouchesRequired: UInt) {
        self.numberOfTouchesRequired = Int(numberOfTouchesRequired)
    }
    
    func kk_update(minimumDuration: TimeInterval) {
        self.minimumPressDuration = minimumDuration
    }
    
    func kk_update(allowableMovement: Double) {
        self.allowableMovement = CGFloat(allowableMovement)
    }
    
    func kk_cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKLongTapGesture {
    
    @objc
    func _handle() {
        self.kkDelegate?.triggered(self)
    }
    
}

extension KKLongTapGesture : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldBegin(self) ?? true
    }

    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldSimultaneously(self, otherGesture: otherGesture) ?? false
    }
    
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRequireFailureOf otherGesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldRequireFailureOf(self, otherGesture: otherGesture) ?? false
    }

    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldBeRequiredToFailBy otherGesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldBeRequiredToFailBy(self, otherGesture: otherGesture) ?? false
    }
    
}

#endif
