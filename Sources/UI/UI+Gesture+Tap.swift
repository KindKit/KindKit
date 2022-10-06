//
//  KindKit
//

import Foundation

protocol KKTapGestureDelegate : KKGestureDelegate {
    
    func triggered(_ gesture: NativeGesture)
    
}

public extension UI.Gesture {
    
    final class Tap : IUIGesture {        
        
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
        public var numberOfTapsRequired: UInt = 1 {
            didSet {
                guard self.numberOfTapsRequired != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(numberOfTapsRequired: self.numberOfTapsRequired)
                }
            }
        }
        public var numberOfTouchesRequired: UInt = 1 {
            didSet {
                guard self.numberOfTouchesRequired != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.update(numberOfTouchesRequired: self.numberOfTouchesRequired)
                }
            }
        }
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
        @inline(__always) private var _gesture: Reusable.Content { return self._reuse.content }
        private var _onShouldBegin: ((UI.Gesture.Tap) -> Bool)?
        private var _onShouldSimultaneously: ((UI.Gesture.Tap, NativeGesture) -> Bool)?
        private var _onShouldRequireFailure: ((UI.Gesture.Tap, NativeGesture) -> Bool)?
        private var _onShouldBeRequiredToFailBy: ((UI.Gesture.Tap, NativeGesture) -> Bool)?
        private var _onTriggered: ((UI.Gesture.Tap) -> Void)?
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
                
        @discardableResult
        public func onShouldBegin(_ value: ((UI.Gesture.Tap) -> Bool)?) -> Self {
            self._onShouldBegin = value
            return self
        }
        
        @discardableResult
        public func onShouldSimultaneously(_ value: ((UI.Gesture.Tap, NativeGesture) -> Bool)?) -> Self {
            self._onShouldSimultaneously = value
            return self
        }
        
        @discardableResult
        public func onShouldRequireFailure(_ value: ((UI.Gesture.Tap, NativeGesture) -> Bool)?) -> Self {
            self._onShouldRequireFailure = value
            return self
        }
        
        @discardableResult
        public func onShouldBeRequiredToFailBy(_ value: ((UI.Gesture.Tap, NativeGesture) -> Bool)?) -> Self {
            self._onShouldBeRequiredToFailBy = value
            return self
        }
        
        @discardableResult
        public func onTriggered(_ value: ((UI.Gesture.Tap) -> Void)?) -> Self {
            self._onTriggered = value
            return self
        }
        
    }
    
}

public extension UI.Gesture.Tap {
        
    @discardableResult
    func numberOfTapsRequired(_ value: UInt) -> Self {
        self.numberOfTapsRequired = value
        return self
    }
    
    @discardableResult
    func numberOfTouchesRequired(_ value: UInt) -> Self {
        self.numberOfTouchesRequired = value
        return self
    }
    
}

extension UI.Gesture.Tap : KKGestureDelegate {
    
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

extension UI.Gesture.Tap : KKTapGestureDelegate {
    
    func triggered(_ gesture: NativeGesture) {
        self._onTriggered?(self)
    }
    
}
