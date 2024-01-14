//
//  KindKit
//

#if os(macOS)

import AppKit

extension PanGesture {
    
    struct Reusable : IReusable {
        
        typealias Owner = PanGesture
        typealias Content = KKPanGesture

        static var reuseIdentificator: String {
            return "PanGesture"
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

final class KKPanGesture : NSPanGestureRecognizer {
    
    weak var kkDelegate: KKPanGestureDelegate?
    
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

extension KKPanGesture {
    
    func update(gesture: PanGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(delaysEvents: gesture.delaysEvents, buttons: gesture.buttons)
        self.kkDelegate = gesture
    }
    
    func kk_update(delaysEvents: Bool, buttons: GestureButtons) {
        self.delaysPrimaryMouseButtonEvents = buttons.delayPrimary
        self.delaysSecondaryMouseButtonEvents = buttons.delaySecondary
        self.delaysOtherMouseButtonEvents = buttons.delayOther
        self.buttonMask = buttons.mask
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

extension KKPanGesture : NSGestureRecognizerDelegate {
    
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
