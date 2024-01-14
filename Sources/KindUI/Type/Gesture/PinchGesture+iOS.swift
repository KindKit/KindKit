//
//  KindKit
//

#if os(iOS)

import UIKit

extension PinchGesture {
    
    struct Reusable : IReusable {
        
        typealias Owner = PinchGesture
        typealias Content = KKPinchGesture

        static var reuseIdentificator: String {
            return "PinchGesture"
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

final class KKPinchGesture : UIPinchGestureRecognizer {
    
    weak var kkDelegate: KKPinchGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }

}

extension KKPinchGesture {
    
    func update(gesture: PinchGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(cancelsTouchesInView: gesture.cancelsTouchesInView)
        self.kk_update(delaysTouchesBegan: gesture.delaysTouchesBegan)
        self.kk_update(delaysTouchesEnded: gesture.delaysTouchesEnded)
        self.kk_update(requiresExclusiveTouchType: gesture.requiresExclusiveTouchType)
        self.kkDelegate = gesture
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKPinchGesture {
    
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

extension KKPinchGesture : UIGestureRecognizerDelegate {
    
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
