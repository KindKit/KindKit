//
//  KindKit
//

import Foundation

protocol KKLongTapGestureDelegate : KKGestureDelegate {
    
    func triggered(_ gesture: NativeGesture)
    
}

public extension UI.Gesture {
    
    final class LongTap {
        
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
        public var buttons: UI.Gesture.Buttons = .primary {
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
        public var numberOfTapsRequired: UInt = 1 {
            didSet {
                guard self.numberOfTapsRequired != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(numberOfTapsRequired: self.numberOfTapsRequired)
                }
            }
        }
#endif
        public var numberOfTouchesRequired: UInt = 1 {
            didSet {
                guard self.numberOfTouchesRequired != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(numberOfTouchesRequired: self.numberOfTouchesRequired)
                }
            }
        }
        public var minimumDuration: TimeInterval = 0.5 {
            didSet {
                guard self.minimumDuration != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(minimumDuration: self.minimumDuration)
                }
            }
        }
        public var allowableMovement: Double = 10 {
            didSet {
                guard self.allowableMovement != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(allowableMovement: self.allowableMovement)
                }
            }
        }
        public let onShouldBegin: Signal.Empty< Bool? > = .init()
        public let onShouldSimultaneously: Signal.Args< Bool?, NativeGesture > = .init()
        public let onShouldRequireFailure: Signal.Args< Bool?, NativeGesture > = .init()
        public let onShouldBeRequiredToFailBy: Signal.Args< Bool?, NativeGesture > = .init()
        public let onTriggered: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
        @inline(__always) private var _gesture: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.Gesture.LongTap {
    
#if os(macOS)
    
    @inlinable
    @discardableResult
    func buttons(_ value: UI.Gesture.Buttons) -> Self {
        self.buttons = value
        return self
    }
    
    @inlinable
    @discardableResult
    func buttons(_ value: (Self) -> UI.Gesture.Buttons) -> Self {
        return self.buttons(value(self))
    }
    
#elseif os(iOS)
    
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
    
#endif
    
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
    
    @inlinable
    @discardableResult
    func minimumDuration(_ value: TimeInterval) -> Self {
        self.minimumDuration = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minimumDuration(_ value: (Self) -> TimeInterval) -> Self {
        return self.minimumDuration(value(self))
    }
    
    @inlinable
    @discardableResult
    func allowableMovement(_ value: Double) -> Self {
        self.allowableMovement = value
        return self
    }
    
    @inlinable
    @discardableResult
    func allowableMovement(_ value: (Self) -> Double) -> Self {
        return self.allowableMovement(value(self))
    }
    
}

extension UI.Gesture.LongTap : IUIGesture {
}

extension UI.Gesture.LongTap : IUIGestureTriggerable {
}

extension UI.Gesture.LongTap : KKGestureDelegate {
    
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

extension UI.Gesture.LongTap : KKTapGestureDelegate {
    
    func triggered(_ gesture: NativeGesture) {
        self.onTriggered.emit()
    }
    
}

public extension IUIGesture where Self == UI.Gesture.LongTap {
    
    @inlinable
    static func longTap() -> Self {
        return .init()
    }
    
}
