//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.Gesture.Pan {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.Gesture.Pan
        typealias Content = KKPanGesture

        static var reuseIdentificator: String {
            return "UI.Gesture.Pan"
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

final class KKPanGesture : UIPanGestureRecognizer {
    
    unowned var kkDelegate: KKPanGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }

}

extension KKPanGesture {
    
    func update(gesture: UI.Gesture.Pan) {
        self.update(enabled: gesture.isEnabled)
        self.update(cancelsTouchesInView: gesture.cancelsTouchesInView)
        self.update(delaysTouchesBegan: gesture.delaysTouchesBegan)
        self.update(delaysTouchesEnded: gesture.delaysTouchesEnded)
        self.update(requiresExclusiveTouchType: gesture.requiresExclusiveTouchType)
        self.kkDelegate = gesture
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKPanGesture {
    
    @objc
    func _handle() {
        switch self.state {
        case .possible: break
        case .began: self.kkDelegate?.begin(self)
        case .changed: self.kkDelegate?.changed(self)
        case .cancelled: self.kkDelegate?.cancel(self)
        case .ended, .failed: self.kkDelegate?.end(self)
        @unknown default: break
        }
    }
    
}

extension KKPanGesture : UIGestureRecognizerDelegate {
    
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
