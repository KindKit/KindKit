//
//  KindKit
//

#if os(macOS)

import AppKit

extension TapGesture {
    
    struct Reusable : IReusable {
        
        typealias Owner = TapGesture
        typealias Content = KKTapGesture
        
        static func name(owner: Owner) -> String {
            return "TapGesture"
        }
        
        static func create(owner: Owner) -> Content {
            return .init()
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(gesture: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(gesture: owner)
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
    
    func kk_update(gesture: TapGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(delays: gesture.delays, button: gesture.button)
        self.kk_update(numberOfTapsRequired: gesture.numberOfTapsRequired)
        self.kk_update(numberOfTouchesRequired: gesture.numberOfTouchesRequired)
        self.kkDelegate = gesture
    }
    
    func kk_cleanup(gesture: TapGesture) {
        self.kkDelegate = nil
    }
    
}

extension KKTapGesture {
    
    func kk_update(delays: Bool, button: Mouse.Button) {
        self.delaysPrimaryMouseButtonEvents = button.gestureDelayPrimary == true && delays == true
        self.delaysSecondaryMouseButtonEvents = button.gestureDelaySecondary == true && delays == true
        self.delaysOtherMouseButtonEvents = button.gestureDelayOther == true && delays == true
        self.buttonMask = .init(button.bitMask)
    }
    
    func kk_update(numberOfTapsRequired: UInt) {
        self.numberOfClicksRequired = Int(numberOfTapsRequired)
    }
    
    func kk_update(numberOfTouchesRequired: UInt) {
        self.numberOfTouchesRequired = Int(numberOfTouchesRequired)
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
