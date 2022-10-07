//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKEdgePanGestureDelegate : KKGestureDelegate {
    
    func begin(_ gesture: NativeGesture)
    func changed(_ gesture: NativeGesture)
    func cancel(_ gesture: NativeGesture)
    func end(_ gesture: NativeGesture)
    
}

public extension UI.Gesture {
    
    final class EdgePan : IUIGesture {
        
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
        public var delaysPrimaryMouseButtonEvents: Bool = false {
            didSet {
                guard self.delaysPrimaryMouseButtonEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysPrimaryMouseButtonEvents: self.delaysPrimaryMouseButtonEvents)
                }
            }
        }
        public var delaysSecondaryMouseButtonEvents: Bool = false {
            didSet {
                guard self.delaysSecondaryMouseButtonEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysSecondaryMouseButtonEvents:
                                            self.delaysSecondaryMouseButtonEvents)
                }
            }
        }
        public var delaysOtherMouseButtonEvents: Bool = false {
            didSet {
                guard self.delaysOtherMouseButtonEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysOtherMouseButtonEvents: self.delaysOtherMouseButtonEvents)
                }
            }
        }
        public var delaysKeyEvents: Bool = false {
            didSet {
                guard self.delaysKeyEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysKeyEvents: self.delaysKeyEvents)
                }
            }
        }
        public var delaysMagnificationEvents: Bool = false {
            didSet {
                guard self.delaysMagnificationEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysMagnificationEvents: self.delaysMagnificationEvents)
                }
            }
        }
        public var delaysRotationEvents: Bool = false {
            didSet {
                guard self.delaysRotationEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysRotationEvents: self.delaysRotationEvents)
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
        public var mode: Mode {
            didSet {
                guard self.mode != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(mode: self.mode)
                }
            }
        }
        public let onShouldBegin: Signal.Empty< Bool? > = .init()
        public let onShouldSimultaneously: Signal.Args< Bool?, NativeGesture > = .init()
        public let onShouldRequireFailure: Signal.Args< Bool?, NativeGesture > = .init()
        public let onShouldBeRequiredToFailBy: Signal.Args< Bool?, NativeGesture > = .init()
        public let onBegin: Signal.Empty< Void > = .init()
        public let onChange: Signal.Empty< Void > = .init()
        public let onCancel: Signal.Empty< Void > = .init()
        public let onEnd: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
        @inline(__always) private var _gesture: Reusable.Content { return self._reuse.content }

        public init(_ mode: Mode) {
            self.mode = mode
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func translation(in view: IUIView) -> PointFloat {
            return PointFloat(self._gesture.translation(in: view.native))
        }
        
        public func velocity(in view: IUIView) -> PointFloat {
            return PointFloat(self._gesture.velocity(in: view.native))
        }
        
    }
    
}

public extension UI.Gesture.EdgePan {
    
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }

}

public extension UI.Gesture.EdgePan {
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: (() -> Void)?) -> Self {
        self.onBegin.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: ((Self) -> Void)?) -> Self {
        self.onBegin.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onBegin.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(_ closure: (() -> Void)?) -> Self {
        self.onChange.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(_ closure: ((Self) -> Void)?) -> Self {
        self.onChange.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onChange.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel(_ closure: (() -> Void)?) -> Self {
        self.onCancel.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel(_ closure: ((Self) -> Void)?) -> Self {
        self.onCancel.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onCancel.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: (() -> Void)?) -> Self {
        self.onEnd.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: ((Self) -> Void)?) -> Self {
        self.onEnd.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onEnd.set(sender, closure)
        return self
    }
    
}

extension UI.Gesture.EdgePan : KKGestureDelegate {
    
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

extension UI.Gesture.EdgePan : KKEdgePanGestureDelegate {
    
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

#endif
