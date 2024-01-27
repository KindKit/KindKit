//
//  KindKit
//

#if os(macOS)

import AppKit

extension PanGesture {
    
    struct Reusable : IReusable {
        
        typealias Owner = PanGesture
        typealias Content = KKPanGesture
        
        static func name(owner: Owner) -> String {
            return "PanGesture"
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
    
    func kk_update(gesture: PanGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(delays: gesture.delays, button: gesture.button)
        self.kkDelegate = gesture
    }
    
    func kk_cleanup(gesture: PanGesture) {
        self.kkDelegate = nil
    }
    
}

extension KKPanGesture {
    
    func kk_update(delays: Bool, button: Mouse.Button) {
        self.delaysPrimaryMouseButtonEvents = button.gestureDelayPrimary == true && delays == true
        self.delaysSecondaryMouseButtonEvents = button.gestureDelaySecondary == true && delays == true
        self.delaysOtherMouseButtonEvents = button.gestureDelayOther == true && delays == true
        self.buttonMask = .init(button.bitMask)
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
