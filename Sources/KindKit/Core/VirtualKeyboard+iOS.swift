//
//  KindKit
//

#if os(iOS)

import UIKit

public protocol IVirtualKeyboardObserver {

    func willShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info)
    func didShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info)

    func willHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info)
    func didHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info)

}

public final class VirtualKeyboard {

    private var _observer: Observer< IVirtualKeyboardObserver >

    public init() {
        self._observer = Observer< IVirtualKeyboardObserver >()
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

    public func add(observer: IVirtualKeyboardObserver, priority: ObserverPriority) {
        self._observer.add(observer, priority: priority)
    }

    public func remove(observer: IVirtualKeyboardObserver) {
        self._observer.remove(observer)
    }
    
}

public extension VirtualKeyboard {
    
    struct Info {

        public let beginFrame: Rect
        public let endFrame: Rect
        public let duration: TimeInterval

        init?(_ userInfo: [AnyHashable : Any]) {
            guard let beginFrameValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return nil }
            guard let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
            guard let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
            self.beginFrame = Rect(beginFrameValue.cgRectValue)
            self.endFrame = Rect(endFrameValue.cgRectValue)
            self.duration = TimeInterval(durationValue.doubleValue)
        }

    }

}

extension VirtualKeyboard {
    
    @objc
    private func _willShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self._observer.notify({ $0.willShow(virtualKeyboard: self, info: info) })
    }

    @objc
    private func _didShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self._observer.notify({ $0.didShow(virtualKeyboard: self, info: info) })
    }

    @objc
    private func _willHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self._observer.notify({ $0.willHide(virtualKeyboard: self, info: info) })
    }

    @objc
    private func _didHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = Info(userInfo) else { return }
        self._observer.notify({ $0.didHide(virtualKeyboard: self, info: info) })
    }

}

#endif
