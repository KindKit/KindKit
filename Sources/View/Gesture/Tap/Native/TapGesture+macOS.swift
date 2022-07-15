//
//  KindKitView
//

#if os(macOS)

import AppKit
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
    public var delaysPrimaryMouseButtonEvents: Bool {
        set(value) { self._native.delaysPrimaryMouseButtonEvents = value }
        get { return self._native.delaysPrimaryMouseButtonEvents }
    }
    public var delaysSecondaryMouseButtonEvents: Bool {
        set(value) { self._native.delaysSecondaryMouseButtonEvents = value }
        get { return self._native.delaysSecondaryMouseButtonEvents }
    }
    public var delaysOtherMouseButtonEvents: Bool {
        set(value) { self._native.delaysOtherMouseButtonEvents = value }
        get { return self._native.delaysOtherMouseButtonEvents }
    }
    public var delaysKeyEvents: Bool {
        set(value) { self._native.delaysKeyEvents = value }
        get { return self._native.delaysKeyEvents }
    }
    public var delaysMagnificationEvents: Bool {
        set(value) { self._native.delaysMagnificationEvents = value }
        get { return self._native.delaysMagnificationEvents }
    }
    public var delaysRotationEvents: Bool {
        set(value) { self._native.delaysRotationEvents = value }
        get { return self._native.delaysRotationEvents }
    }
    public var numberOfTapsRequired: UInt {
        set(value) { self._native.numberOfClicksRequired = Int(value) }
        get { return UInt(self._native.numberOfClicksRequired) }
    }
    public var numberOfTouchesRequired: UInt {
        set(value) { self._native.numberOfTouchesRequired = Int(value) }
        get { return UInt(self._native.numberOfTouchesRequired) }
    }
    
    private var _native: NSClickGestureRecognizer
    private var _onShouldBegin: (() -> Bool)?
    private var _onShouldSimultaneously: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onShouldRequireFailure: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onShouldBeRequiredToFailBy: ((_ otherGesture: NativeGesture) -> Bool)?
    private var _onTriggered: (() -> Void)?
    
    public init(
        isEnabled: Bool = true,
        delaysPrimaryMouseButtonEvents: Bool = false,
        delaysSecondaryMouseButtonEvents: Bool = false,
        delaysOtherMouseButtonEvents: Bool = false,
        delaysKeyEvents: Bool = false,
        delaysMagnificationEvents: Bool = false,
        delaysRotationEvents: Bool = false,
        numberOfTapsRequired: UInt = 1,
        numberOfTouchesRequired: UInt = 1
    ) {
        self._native = NSClickGestureRecognizer()
        self._native.isEnabled = isEnabled
        self._native.delaysPrimaryMouseButtonEvents = delaysPrimaryMouseButtonEvents
        self._native.delaysSecondaryMouseButtonEvents = delaysSecondaryMouseButtonEvents
        self._native.delaysOtherMouseButtonEvents = delaysOtherMouseButtonEvents
        self._native.delaysKeyEvents = delaysKeyEvents
        self._native.delaysMagnificationEvents = delaysMagnificationEvents
        self._native.numberOfClicksRequired = Int(numberOfTapsRequired)
        self._native.numberOfTouchesRequired = Int(numberOfTouchesRequired)
        super.init()
        self._native.delegate = self
        self._native.target = self
        self._native.action = #selector(self._handle)
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

extension TapGesture : NSGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
        return self._onShouldBegin?() ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        return self._onShouldSimultaneously?(otherGestureRecognizer) ?? false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        return self._onShouldRequireFailure?(otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        return self._onShouldBeRequiredToFailBy?(otherGestureRecognizer) ?? false
    }
    
}

#endif
