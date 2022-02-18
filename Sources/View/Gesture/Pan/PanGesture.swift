//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

public final class PanGesture : NSObject, IPanGesture {
    
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
    @available(iOS 9.2, *)
    public var requiresExclusiveTouchType: Bool {
        set(value) { self._native.requiresExclusiveTouchType = value }
        get { return self._native.requiresExclusiveTouchType }
    }
    
    private var _native: UIPanGestureRecognizer
    private var _onShouldBegin: (() -> Bool)?
    private var _onShouldSimultaneously: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onShouldRequireFailure: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onShouldBeRequiredToFailBy: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onBegin: (() -> Void)?
    private var _onChange: (() -> Void)?
    private var _onCancel: (() -> Void)?
    private var _onEnd: (() -> Void)?
    
    public init(
        isEnabled: Bool = true,
        cancelsTouchesInView: Bool = true,
        delaysTouchesBegan: Bool = false,
        delaysTouchesEnded: Bool = true
    ) {
        let native = UIPanGestureRecognizer()
        native.isEnabled = isEnabled
        native.cancelsTouchesInView = cancelsTouchesInView
        native.delaysTouchesBegan = delaysTouchesBegan
        native.delaysTouchesEnded = delaysTouchesEnded
        self._native = native
        super.init()
        self._native.delegate = self
        self._native.addTarget(self, action: #selector(self._handle))
    }
    
    @available(iOS 9.2, *)
    public init(
        isEnabled: Bool = true,
        cancelsTouchesInView: Bool = false,
        delaysTouchesBegan: Bool = false,
        delaysTouchesEnded: Bool = true,
        requiresExclusiveTouchType: Bool = true
    ) {
        let native = UIPanGestureRecognizer()
        native.isEnabled = isEnabled
        native.cancelsTouchesInView = cancelsTouchesInView
        native.delaysTouchesBegan = delaysTouchesBegan
        native.delaysTouchesEnded = delaysTouchesEnded
        native.requiresExclusiveTouchType = requiresExclusiveTouchType
        self._native = native
        super.init()
        self._native.delegate = self
        self._native.addTarget(self, action: #selector(self._handle))
    }
    
    public init(
        isEnabled: Bool = true,
        cancelsTouchesInView: Bool = false,
        delaysTouchesBegan: Bool = false,
        delaysTouchesEnded: Bool = true,
        screenEdge: ScreenEdge
    ) {
        let native = UIScreenEdgePanGestureRecognizer()
        native.isEnabled = isEnabled
        native.cancelsTouchesInView = cancelsTouchesInView
        native.delaysTouchesBegan = delaysTouchesBegan
        native.delaysTouchesEnded = delaysTouchesEnded
        switch screenEdge {
        case .top: native.edges = [ .top ]
        case .left: native.edges = [ .left ]
        case .right: native.edges = [ .right ]
        case .bottom: native.edges = [ .bottom ]
        }
        self._native = native
        super.init()
        self._native.delegate = self
        self._native.addTarget(self, action: #selector(self._handle))
    }
    
    @available(iOS 9.2, *)
    public init(
        isEnabled: Bool = true,
        cancelsTouchesInView: Bool = true,
        delaysTouchesBegan: Bool = false,
        delaysTouchesEnded: Bool = true,
        requiresExclusiveTouchType: Bool = true,
        screenEdge: ScreenEdge
    ) {
        let native = UIScreenEdgePanGestureRecognizer()
        native.isEnabled = isEnabled
        native.cancelsTouchesInView = cancelsTouchesInView
        native.delaysTouchesBegan = delaysTouchesBegan
        native.delaysTouchesEnded = delaysTouchesEnded
        native.requiresExclusiveTouchType = requiresExclusiveTouchType
        switch screenEdge {
        case .top: native.edges = [ .top ]
        case .left: native.edges = [ .left ]
        case .right: native.edges = [ .right ]
        case .bottom: native.edges = [ .bottom ]
        }
        self._native = native
        super.init()
        self._native.delegate = self
        self._native.addTarget(self, action: #selector(self._handle))
    }
    
    public func require(toFail gesture: NativeGesture) {
        self.native.require(toFail: gesture)
    }
    
    public func translation(in view: IView) -> PointFloat {
        return PointFloat(self._native.translation(in: view.native))
    }
    
    public func velocity(in view: IView) -> PointFloat {
        return PointFloat(self._native.velocity(in: view.native))
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
    public func onBegin(_ value: (() -> Void)?) -> Self {
        self._onBegin = value
        return self
    }
    
    @discardableResult
    public func onChange(_ value: (() -> Void)?) -> Self {
        self._onChange = value
        return self
    }
    
    @discardableResult
    public func onCancel(_ value: (() -> Void)?) -> Self {
        self._onCancel = value
        return self
    }
    
    @discardableResult
    public func onEnd(_ value: (() -> Void)?) -> Self {
        self._onEnd = value
        return self
    }
    
}

public extension PanGesture {
    
    enum ScreenEdge {
        case top
        case left
        case right
        case bottom
    }
    
}

private extension PanGesture {
    
    @objc
    func _handle() {
        switch self._native.state {
        case .possible: break
        case .began: self._onBegin?()
        case .changed: self._onChange?()
        case .cancelled: self._onCancel?()
        case .ended, .failed: self._onEnd?()
        @unknown default: break
        }
    }
    
}

extension PanGesture : UIGestureRecognizerDelegate {
    
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
