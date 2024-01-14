//
//  KindKit
//

#if os(macOS)

import AppKit

extension LongTapGesture {
    
    struct Reusable : IReusable {
        
        typealias Owner = LongTapGesture
        typealias Content = KKLongTapGesture

        static var reuseIdentificator: String {
            return "LongTapGesture"
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

final class KKLongTapGesture : NSPressGestureRecognizer {
    
    weak var kkDelegate: KKTapGestureDelegate?
    
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

extension KKLongTapGesture {
    
    func kk_update(gesture: LongTapGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(delaysEvents: gesture.delaysEvents, buttons: gesture.buttons)
        self.kk_update(numberOfTouchesRequired: gesture.numberOfTouchesRequired)
        self.kk_update(minimumDuration: gesture.minimumDuration)
        self.kk_update(allowableMovement: gesture.allowableMovement)
        self.kkDelegate = gesture
    }
    
    func kk_update(delaysEvents: Bool, buttons: GestureButtons) {
        self.delaysPrimaryMouseButtonEvents = buttons.delayPrimary
        self.delaysSecondaryMouseButtonEvents = buttons.delaySecondary
        self.delaysOtherMouseButtonEvents = buttons.delayOther
        self.buttonMask = buttons.mask
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

extension KKLongTapGesture : NSGestureRecognizerDelegate {
    
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
