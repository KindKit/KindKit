//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

public final class TapGesture : NSObject, ITapGesture {
    
    public var native: NativeGesture {
        return self._native
    }
    public var isEnabled: Bool {
        set(value) { self._native.isEnabled = value }
        get { return self._native.isEnabled }
    }
    public var cancelsTouchesInView: Bool {
        set(value) { self._native.cancelsTouchesInView = value }
        get { return self._native.cancelsTouchesInView }
    }
    public var delaysTouchesBegan: Bool {
        set(value) { self._native.delaysTouchesBegan = value }
        get { return self._native.delaysTouchesBegan }
    }
    public var delaysTouchesEnded: Bool {
        set(value) { self._native.delaysTouchesEnded = value }
        get { return self._native.delaysTouchesEnded }
    }
    public var requiresExclusiveTouchType: Bool {
        set(value) { self._native.requiresExclusiveTouchType = value }
        get { return self._native.requiresExclusiveTouchType }
    }
    public var numberOfTapsRequired: UInt {
        set(value) { self._native.numberOfTapsRequired = Int(value) }
        get { return UInt(self._native.numberOfTapsRequired) }
    }
    public var numberOfTouchesRequired: UInt {
        set(value) { self._native.numberOfTouchesRequired = Int(value) }
        get { return UInt(self._native.numberOfTouchesRequired) }
    }
    
    private var _native: UITapGestureRecognizer
    private var _onShouldBegin: (() -> Bool)?
    private var _onShouldSimultaneously: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onShouldRequireFailure: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onShouldBeRequiredToFailBy: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onTriggered: (() -> Void)?
    
    public init(
        isEnabled: Bool = true,
        cancelsTouchesInView: Bool = false,
        delaysTouchesBegan: Bool = false,
        delaysTouchesEnded: Bool = true,
        requiresExclusiveTouchType: Bool = true,
        numberOfTapsRequired: UInt = 1,
        numberOfTouchesRequired: UInt = 1
    ) {
        self._native = UITapGestureRecognizer()
        self._native.isEnabled = isEnabled
        self._native.cancelsTouchesInView = cancelsTouchesInView
        self._native.delaysTouchesBegan = delaysTouchesBegan
        self._native.delaysTouchesEnded = delaysTouchesEnded
        self._native.requiresExclusiveTouchType = requiresExclusiveTouchType
        self._native.numberOfTapsRequired = Int(numberOfTapsRequired)
        self._native.numberOfTouchesRequired = Int(numberOfTouchesRequired)
        super.init()
        self._native.delegate = self
        self._native.addTarget(self, action: #selector(self._handle))
    }
    
    public func require(toFail gesture: NativeGesture) {
        self.native.require(toFail: gesture)
    }
    
    public func location(in view: IView) -> PointFloat {
        return PointFloat(self._native.location(in: view.native))
    }
    
    @discardableResult
    public func enabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }
    
    @discardableResult
    public func numberOfTapsRequired(_ value: UInt) -> Self {
        self.numberOfTapsRequired = value
        return self
    }
    
    @discardableResult
    public func numberOfTouchesRequired(_ value: UInt) -> Self {
        self.numberOfTouchesRequired = value
        return self
    }
    
    @discardableResult
    public func onShouldBegin(_ value: (() -> Bool)?) -> Self {
        self._onShouldBegin = value
        return self
    }
    
    @discardableResult
    public func onShouldSimultaneously(_ value: ((_ otherGesture: NativeGesture) -> Bool)?) -> Self {
        self._onShouldSimultaneously = value
        return self
    }
    
    @discardableResult
    public func onShouldRequireFailure(_ value: ((_ otherGesture: NativeGesture) -> Bool)?) -> Self {
        self._onShouldRequireFailure = value
        return self
    }
    
    @discardableResult
    public func onShouldBeRequiredToFailBy(_ value: ((_ otherGesture: NativeGesture) -> Bool)?) -> Self {
        self._onShouldBeRequiredToFailBy = value
        return self
    }
    
    @discardableResult
    public func onTriggered(_ value: (() -> Void)?) -> Self {
        self._onTriggered = value
        return self
    }
    
}

private extension TapGesture {
    
    @objc
    func _handle() {
        self._onTriggered?()
    }
    
}

extension TapGesture : UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self._onShouldBegin?() ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self._onShouldSimultaneously?(otherGestureRecognizer) ?? false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self._onShouldRequireFailure?(otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self._onShouldBeRequiredToFailBy?(otherGestureRecognizer) ?? false
    }
    
}

#endif
