//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.Gesture.Tap {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.Gesture.Tap
        typealias Content = KKTapGesture

        static var reuseIdentificator: String {
            return "UI.Gesture.Tap"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content()
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(gesture: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKTapGesture : UITapGestureRecognizer {
    
    unowned var kkDelegate: KKTapGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }
    
}

extension KKTapGesture {
    
    func update(gesture: UI.Gesture.Tap) {
        self.update(enabled: gesture.isEnabled)
        self.update(cancelsTouchesInView: gesture.cancelsTouchesInView)
        self.update(delaysTouchesBegan: gesture.delaysTouchesBegan)
        self.update(delaysTouchesEnded: gesture.delaysTouchesEnded)
        self.update(requiresExclusiveTouchType: gesture.requiresExclusiveTouchType)
        self.update(numberOfTapsRequired: gesture.numberOfTapsRequired)
        self.update(numberOfTouchesRequired: gesture.numberOfTouchesRequired)
        self.kkDelegate = gesture
    }
    
    func update(numberOfTapsRequired: UInt) {
        self.numberOfTapsRequired = Int(numberOfTapsRequired)
    }
    
    func update(numberOfTouchesRequired: UInt) {
        self.numberOfTouchesRequired = Int(numberOfTouchesRequired)
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKTapGesture {
    
    @objc
    func _handle() {
        self.kkDelegate?.triggered(self)
    }
    
}

extension KKTapGesture : UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldBegin(self) ?? true
    }

    public func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldSimultaneously(self, otherGesture: otherGesture) ?? false
    }
    
    public func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRequireFailureOf otherGesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldRequireFailureOf(self, otherGesture: otherGesture) ?? false
    }

    public func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldBeRequiredToFailBy otherGesture: UIGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldBeRequiredToFailBy(self, otherGesture: otherGesture) ?? false
    }
    
}

#endif
