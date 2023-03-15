//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.Gesture.EdgePan {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.Gesture.EdgePan
        typealias Content = KKEdgePanGesture

        static var reuseIdentificator: String {
            return "UI.Gesture.EdgePan"
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

final class KKEdgePanGesture : UIScreenEdgePanGestureRecognizer {
    
    weak var kkDelegate: KKEdgePanGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }

}

extension KKEdgePanGesture {
    
    func update(gesture: UI.Gesture.EdgePan) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(cancelsTouchesInView: gesture.cancelsTouchesInView)
        self.kk_update(delaysTouchesBegan: gesture.delaysTouchesBegan)
        self.kk_update(delaysTouchesEnded: gesture.delaysTouchesEnded)
        self.kk_update(requiresExclusiveTouchType: gesture.requiresExclusiveTouchType)
        self.update(mode: gesture.mode)
        self.kkDelegate = gesture
    }
    
    func update(mode: UI.Gesture.EdgePan.Mode) {
        switch mode {
        case .top: self.edges = .top
        case .left: self.edges = .left
        case .right: self.edges = .right
        case .bottom: self.edges = .bottom
        }
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKEdgePanGesture {
    
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

extension KKEdgePanGesture : UIGestureRecognizerDelegate {
    
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
