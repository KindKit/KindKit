//
//  KindKit
//

import KindEvent
import KindMath

protocol KKPanGestureDelegate : KKGestureDelegate {
    
    func begin(_ gesture: NativeGesture)
    func changed(_ gesture: NativeGesture)
    func cancel(_ gesture: NativeGesture)
    func end(_ gesture: NativeGesture)
    
}

public final class PanGesture {
    
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
    public let onShouldBegin = Signal< Bool?, Void >()
    public let onShouldSimultaneously = Signal< Bool?, NativeGesture >()
    public let onShouldRequireFailure = Signal< Bool?, NativeGesture >()
    public let onShouldBeRequiredToFailBy = Signal< Bool?, NativeGesture >()
    public let onBegin = Signal< Void, Void >()
    public let onChange = Signal< Void, Void >()
    public let onCancel = Signal< Void, Void >()
    public let onEnd = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
    @inline(__always) private var _gesture: Reusable.Content { self._reuse.content }

    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
    public func translation(in view: IView) -> Point {
        return Point(self._gesture.translation(in: view.native))
    }
    
    public func velocity(in view: IView) -> Point {
        return Point(self._gesture.velocity(in: view.native))
    }
    
}

extension PanGesture : IGesture {
}

extension PanGesture : IGestureContinusable {
}

extension PanGesture : KKGestureDelegate {
    
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

extension PanGesture : KKPanGestureDelegate {
    
    func begin(_ gesture: NativeGesture) {
        self.onBegin.emit()
    }
    
    func changed(_ gesture: NativeGesture) {
        self.onChange.emit()
    }
    
    func cancel(_ gesture: NativeGesture) {
        self.onCancel.emit()
    }
    
    func end(_ gesture: NativeGesture) {
        self.onEnd.emit()
    }
    
}

public extension IGesture where Self == PanGesture {
    
    @inlinable
    static func pan() -> Self {
        return .init()
    }
    
}
