//
//  KindKit
//

#if os(iOS)

import UIKit

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

final class KKPanGesture : UIPanGestureRecognizer {
    
    weak var kkDelegate: KKPanGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }

}

extension KKPanGesture {
    
    func kk_update(gesture: PanGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(cancelsInView: gesture.cancelsInView)
        self.kk_update(delaysBegan: gesture.delaysBegan)
        self.kk_update(delaysEnded: gesture.delaysEnded)
        self.kk_update(requiresExclusive: gesture.requiresExclusive)
        self.kkDelegate = gesture
    }
    
    func kk_cleanup(gesture: PanGesture) {
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
