//
//  KindKit
//

import KindEvent

protocol KKTapGestureDelegate : KKGestureDelegate {
    
    func triggered(_ gesture: NativeGesture)
    
}

public final class TapGesture {
    
    public var native: NativeGesture {
        return self._gesture
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(enabled: self.isEnabled)
            }
        }
    }
#if os(macOS)
    public var delaysEvents: Bool = false {
        didSet {
            guard self.delaysEvents != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(delaysEvents: self.delaysEvents, buttons: self.buttons)
            }
        }
    }
    public var buttons: GestureButtons = .primary {
        didSet {
            guard self.buttons != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(delaysEvents: self.delaysEvents, buttons: self.buttons)
            }
        }
    }
#elseif os(iOS)
    public var cancelsTouchesInView: Bool = false {
        didSet {
            guard self.cancelsTouchesInView != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(cancelsTouchesInView: self.cancelsTouchesInView)
            }
        }
    }
    public var delaysTouchesBegan: Bool = false {
        didSet {
            guard self.delaysTouchesBegan != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(delaysTouchesBegan: self.delaysTouchesBegan)
            }
        }
    }
    public var delaysTouchesEnded: Bool = true {
        didSet {
            guard self.delaysTouchesEnded != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(delaysTouchesEnded: self.delaysTouchesEnded)
            }
        }
    }
    public var requiresExclusiveTouchType: Bool = true {
        didSet {
            guard self.requiresExclusiveTouchType != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(requiresExclusiveTouchType: self.requiresExclusiveTouchType)
            }
        }
    }
#endif
    public var numberOfTapsRequired: UInt = 1 {
        didSet {
            guard self.numberOfTapsRequired != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(numberOfTapsRequired: self.numberOfTapsRequired)
            }
        }
    }
    public var numberOfTouchesRequired: UInt = 1 {
        didSet {
            guard self.numberOfTouchesRequired != oldValue else { return }
            if self.isLoaded == true {
                self._gesture.kk_update(numberOfTouchesRequired: self.numberOfTouchesRequired)
            }
        }
    }
    public let onShouldBegin = Signal< Bool?, Void >()
    public let onShouldSimultaneously = Signal< Bool?, NativeGesture >()
    public let onShouldRequireFailure = Signal< Bool?, NativeGesture >()
    public let onShouldBeRequiredToFailBy = Signal< Bool?, NativeGesture >()
    public let onTriggered = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
    @inline(__always) private var _gesture: Reusable.Content { self._reuse.content }
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension TapGesture {
    
#if os(macOS)
    
    @inlinable
    @discardableResult
    func buttons(_ value: GestureButtons) -> Self {
        self.buttons = value
        return self
    }
    
    @inlinable
    @discardableResult
    func buttons(_ value: (Self) -> GestureButtons) -> Self {
        return self.buttons(value(self))
    }
    
#endif
    
    @inlinable
    @discardableResult
    func numberOfTapsRequired(_ value: UInt) -> Self {
        self.numberOfTapsRequired = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfTapsRequired(_ value: (Self) -> UInt) -> Self {
        return self.numberOfTapsRequired(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfTouchesRequired(_ value: UInt) -> Self {
        self.numberOfTouchesRequired = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfTouchesRequired(_ value: (Self) -> UInt) -> Self {
        return self.numberOfTouchesRequired(value(self))
    }
    
}

extension TapGesture : IGesture {
}

extension TapGesture : IGestureTriggerable {
}

extension TapGesture : KKGestureDelegate {
    
    func shouldBegin(_ gesture: NativeGesture) -> Bool {
        return self.onShouldBegin.emit(default: true)
    }
    
    func shouldSimultaneously(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self.onShouldSimultaneously.emit(otherGesture, default: false)
    }
    
    func shouldRequireFailureOf(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self.onShouldRequireFailure.emit(otherGesture, default: false)
    }
    
    func shouldBeRequiredToFailBy(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self.onShouldBeRequiredToFailBy.emit(otherGesture, default: false)
    }
    
}

extension TapGesture : KKTapGestureDelegate {
    
    func triggered(_ gesture: NativeGesture) {
        self.onTriggered.emit()
    }
    
}
