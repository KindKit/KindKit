//
//  KindKit
//

#if os(iOS)

import UIKit

extension EdgePanGesture {
    
    struct Reusable : IReusable {
        
        typealias Owner = EdgePanGesture
        typealias Content = KKEdgePanGesture
        
        static func name(owner: Owner) -> String {
            return "EdgePanGesture"
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

final class KKEdgePanGesture : UIScreenEdgePanGestureRecognizer {
    
    weak var kkDelegate: KKEdgePanGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }

}

extension KKEdgePanGesture {
    
    func kk_update(gesture: EdgePanGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(cancelsInView: gesture.cancelsInView)
        self.kk_update(delaysBegan: gesture.delaysBegan)
        self.kk_update(delaysEnded: gesture.delaysEnded)
        self.kk_update(requiresExclusive: gesture.requiresExclusive)
        self.update(mode: gesture.mode)
        self.kkDelegate = gesture
    }
    
    func kk_cleanup(gesture: EdgePanGesture) {
        self.kkDelegate = nil
    }
    
}

extension KKEdgePanGesture {
    
    func update(mode: EdgePanGesture.Mode) {
        switch mode {
        case .top: self.edges = .top
        case .left: self.edges = .left
        case .right: self.edges = .right
        case .bottom: self.edges = .bottom
        }
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
