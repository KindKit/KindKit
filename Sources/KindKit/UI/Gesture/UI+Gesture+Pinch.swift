//
//  KindKit
//

import Foundation

protocol KKPinchGestureDelegate : KKGestureDelegate {
    
    func begin(_ gesture: NativeGesture)
    func changed(_ gesture: NativeGesture)
    func cancel(_ gesture: NativeGesture)
    func end(_ gesture: NativeGesture)
    
}

public extension UI.Gesture {
    
    final class Pinch {
        
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
                    self._gesture.kk_update(delaysEvents: self.delaysEvents)
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
        public var velocity: Double {
            return Double(self._gesture.velocity)
        }
#endif
        public var scale: Double {
#if os(macOS)
            return Double(self._gesture.magnification)
#elseif os(iOS)
            return Double(self._gesture.scale)
#endif
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
        @inline(__always) private var _gesture: Reusable.Content { self._reuse.content }

        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

extension UI.Gesture.Pinch : IUIGesture {
}

extension UI.Gesture.Pinch : IUIGestureContinusable {
}

extension UI.Gesture.Pinch : KKGestureDelegate {
    
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

extension UI.Gesture.Pinch : KKPinchGestureDelegate {
    
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

public extension IUIGesture where Self == UI.Gesture.Pinch {
    
    @inlinable
    static func pinch() -> Self {
        return .init()
    }
    
}
