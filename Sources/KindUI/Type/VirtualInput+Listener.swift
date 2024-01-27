//
//  KindKit
//

#if os(iOS)

import UIKit
import KindMath
import KindEvent
import KindTime
import KindMonadicMacro

extension VirtualInput {
    
    @KindMonadic
    public final class Listener {
        
        public static let `default` = Listener()
        
        @KindMonadicSignal
        public let onWillShow = Signal< Void, Info >()
        
        @KindMonadicSignal
        public let onDidShow = Signal< Void, Info >()
        
        @KindMonadicSignal
        public let onWillHide = Signal< Void, Info >()
        
        @KindMonadicSignal
        public let onDidHide = Signal< Void, Info >()
        
        fileprivate init() {
            NotificationCenter.default.addObserver(self, selector: #selector(self._willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self._didShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self._willHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self._didHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        }
        
    }
    
}

extension VirtualInput.Listener {
    
    public struct Info {

        public let beginFrame: Rect
        public let endFrame: Rect
        public let duration: SecondsInterval

        init?(_ userInfo: [AnyHashable : Any]) {
            guard let beginFrameValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return nil }
            guard let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
            guard let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
            self.beginFrame = .init(beginFrameValue.cgRectValue)
            self.endFrame = .init(endFrameValue.cgRectValue)
            self.duration = .init(durationValue.doubleValue)
        }

    }

}

private extension VirtualInput.Listener {
    
    @objc
    final func _willShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self.onWillShow.emit(info)
    }

    @objc
    final func _didShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self.onDidShow.emit(info)
    }

    @objc
    final func _willHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self.onWillHide.emit(info)
    }

    @objc
    final func _didHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self.onDidHide.emit(info)
    }

}

#endif
