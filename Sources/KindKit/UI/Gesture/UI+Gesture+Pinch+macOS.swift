//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.Gesture.Pinch {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.Gesture.Pinch
        typealias Content = KKPinchGesture

        static var reuseIdentificator: String {
            return "UI.Gesture.Pinch"
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

final class KKPinchGesture : NSMagnificationGestureRecognizer {
    
    weak var kkDelegate: KKPinchGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.target = self
        self.action = #selector(self._handle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension KKPinchGesture {
    
    func update(gesture: UI.Gesture.Pinch) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(delaysPrimaryMouseButtonEvents: gesture.delaysPrimaryMouseButtonEvents)
        self.kk_update(delaysSecondaryMouseButtonEvents: gesture.delaysSecondaryMouseButtonEvents)
        self.kk_update(delaysOtherMouseButtonEvents: gesture.delaysOtherMouseButtonEvents)
        self.kk_update(delaysKeyEvents: gesture.delaysKeyEvents)
        self.kk_update(delaysMagnificationEvents: gesture.delaysMagnificationEvents)
        self.kk_update(delaysRotationEvents: gesture.delaysRotationEvents)
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

extension KKPinchGesture : NSGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gesture: NSGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldBegin(self) ?? true
    }

    func gestureRecognizer(_ gesture: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGesture: NSGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldSimultaneously(self, otherGesture: otherGesture) ?? false
    }
    
    func gestureRecognizer(_ gesture: NSGestureRecognizer, shouldRequireFailureOf otherGesture: NSGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldRequireFailureOf(self, otherGesture: otherGesture) ?? false
    }

    func gestureRecognizer(_ gesture: NSGestureRecognizer, shouldBeRequiredToFailBy otherGesture: NSGestureRecognizer) -> Bool {
        return self.kkDelegate?.shouldBeRequiredToFailBy(self, otherGesture: otherGesture) ?? false
    }
    
}

#endif
