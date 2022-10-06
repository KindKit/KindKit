//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKPinchGestureDelegate : KKGestureDelegate {
    
    func begin(_ gesture: NativeGesture)
    func changed(_ gesture: NativeGesture)
    func cancel(_ gesture: NativeGesture)
    func end(_ gesture: NativeGesture)
    
}

public extension UI.Gesture {
    
    final class Pinch : IUIGesture {
        
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
                    self._gesture.update(enabled: self.isEnabled)
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
                    self._gesture.update(cancelsTouchesInView: self.cancelsTouchesInView)
                }
            }
        }
        public var delaysTouchesBegan: Bool = false {
            didSet {
                guard self.delaysTouchesBegan != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysTouchesBegan: self.delaysTouchesBegan)
                }
            }
        }
        public var delaysTouchesEnded: Bool = true {
            didSet {
                guard self.delaysTouchesEnded != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(delaysTouchesEnded: self.delaysTouchesEnded)
                }
            }
        }
        public var requiresExclusiveTouchType: Bool = true {
            didSet {
                guard self.requiresExclusiveTouchType != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(requiresExclusiveTouchType: self.requiresExclusiveTouchType)
                }
            }
        }
#endif
        public var velocity: Float {
            return Float(self._gesture.velocity)
        }
        public var scale: Float {
            return Float(self._gesture.scale)
        }
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
        @inline(__always) private var _gesture: Reusable.Content { return self._reuse.content }
        private var _onShouldBegin: ((UI.Gesture.Pinch) -> Bool)?
        private var _onShouldSimultaneously: ((UI.Gesture.Pinch, NativeGesture) -> Bool)?
        private var _onShouldRequireFailure: ((UI.Gesture.Pinch, NativeGesture) -> Bool)?
        private var _onShouldBeRequiredToFailBy: ((UI.Gesture.Pinch, NativeGesture) -> Bool)?
        private var _onBegin: ((UI.Gesture.Pinch) -> Void)?
        private var _onChange: ((UI.Gesture.Pinch) -> Void)?
        private var _onCancel: ((UI.Gesture.Pinch) -> Void)?
        private var _onEnd: ((UI.Gesture.Pinch) -> Void)?

        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
                
        @discardableResult
        public func onShouldBegin(_ value: ((UI.Gesture.Pinch) -> Bool)?) -> Self {
            self._onShouldBegin = value
            return self
        }
        
        @discardableResult
        public func onShouldSimultaneously(_ value: ((UI.Gesture.Pinch, NativeGesture) -> Bool)?) -> Self {
            self._onShouldSimultaneously = value
            return self
        }
        
        @discardableResult
        public func onShouldRequireFailure(_ value: ((UI.Gesture.Pinch, NativeGesture) -> Bool)?) -> Self {
            self._onShouldRequireFailure = value
            return self
        }
        
        @discardableResult
        public func onShouldBeRequiredToFailBy(_ value: ((UI.Gesture.Pinch, NativeGesture) -> Bool)?) -> Self {
            self._onShouldBeRequiredToFailBy = value
            return self
        }
        
        @discardableResult
        public func onBegin(_ value: ((UI.Gesture.Pinch) -> Void)?) -> Self {
            self._onBegin = value
            return self
        }
        
        @discardableResult
        public func onChange(_ value: ((UI.Gesture.Pinch) -> Void)?) -> Self {
            self._onChange = value
            return self
        }
        
        @discardableResult
        public func onCancel(_ value: ((UI.Gesture.Pinch) -> Void)?) -> Self {
            self._onCancel = value
            return self
        }
        
        @discardableResult
        public func onEnd(_ value: ((UI.Gesture.Pinch) -> Void)?) -> Self {
            self._onEnd = value
            return self
        }
        
    }
    
}

extension UI.Gesture.Pinch : KKGestureDelegate {
    
    func shouldBegin(_ gesture: NativeGesture) -> Bool {
        return self._onShouldBegin?(self) ?? true
    }
    
    func shouldSimultaneously(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self._onShouldSimultaneously?(self, otherGesture) ?? false
    }
    
    func shouldRequireFailureOf(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self._onShouldRequireFailure?(self, otherGesture) ?? false
    }
    
    func shouldBeRequiredToFailBy(_ gesture: NativeGesture, otherGesture: NativeGesture) -> Bool {
        return self._onShouldBeRequiredToFailBy?(self, otherGesture) ?? false
    }
    
}

extension UI.Gesture.Pinch : KKPinchGestureDelegate {
    
    func begin(_ gesture: NativeGesture) {
        self._onBegin?(self)
    }
    
    func changed(_ gesture: NativeGesture) {
        self._onChange?(self)
    }
    
    func cancel(_ gesture: NativeGesture) {
        self._onCancel?(self)
    }
    
    func end(_ gesture: NativeGesture) {
        self._onEnd?(self)
    }
    
}

#endif
