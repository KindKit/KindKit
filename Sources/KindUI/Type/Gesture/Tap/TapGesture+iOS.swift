//
//  KindKit
//

#if os(iOS)

import UIKit

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

final class KKTapGesture : UITapGestureRecognizer {
    
    weak var kkDelegate: KKTapGestureDelegate?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.delegate = self
        self.addTarget(self, action: #selector(self._handle))
    }
    
}

extension KKTapGesture {
    
    func kk_update(gesture: TapGesture) {
        self.kk_update(enabled: gesture.isEnabled)
        self.kk_update(cancelsInView: gesture.cancelsInView)
        self.kk_update(delaysBegan: gesture.delaysBegan)
        self.kk_update(delaysEnded: gesture.delaysEnded)
        self.kk_update(requiresExclusive: gesture.requiresExclusive)
        self.kk_update(numberOfTapsRequired: gesture.numberOfTapsRequired)
        self.kk_update(numberOfTouchesRequired: gesture.numberOfTouchesRequired)
        self.kkDelegate = gesture
    }
    
    func kk_cleanup(gesture: TapGesture) {
        self.kkDelegate = nil
    }
    
}

extension KKTapGesture {
    
    func kk_update(numberOfTapsRequired: UInt) {
        self.numberOfTapsRequired = Int(numberOfTapsRequired)
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

extension KKTapGesture : UIGestureRecognizerDelegate {
    
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
