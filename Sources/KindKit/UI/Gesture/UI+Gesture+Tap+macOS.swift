//
//  KindKit
//

#if os(macOS)

import AppKit

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

final class KKTapGesture : NSClickGestureRecognizer {
    
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

extension KKTapGesture {
    
    func update(gesture: UI.Gesture.Tap) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(delaysPrimaryMouseButtonEvents: gesture.delaysPrimaryMouseButtonEvents)
        self.kk_update(delaysSecondaryMouseButtonEvents: gesture.delaysSecondaryMouseButtonEvents)
        self.kk_update(delaysOtherMouseButtonEvents: gesture.delaysOtherMouseButtonEvents)
        self.kk_update(delaysKeyEvents: gesture.delaysKeyEvents)
        self.kk_update(delaysMagnificationEvents: gesture.delaysMagnificationEvents)
        self.kk_update(delaysRotationEvents: gesture.delaysRotationEvents)
        self.update(numberOfTapsRequired: gesture.numberOfTapsRequired)
        self.update(numberOfTouchesRequired: gesture.numberOfTouchesRequired)
        self.kkDelegate = gesture
    }
    
    func update(numberOfTapsRequired: UInt) {
        self.numberOfClicksRequired = Int(numberOfTapsRequired)
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

extension KKTapGesture : NSGestureRecognizerDelegate {
    
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
