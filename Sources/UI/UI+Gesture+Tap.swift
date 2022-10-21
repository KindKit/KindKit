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
                    self._gesture.kk_update(enabled: self.isEnabled)
                }
            }
        }
#if os(macOS)
        public var delaysPrimaryMouseButtonEvents: Bool = false {
            didSet {
                guard self.delaysPrimaryMouseButtonEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(delaysPrimaryMouseButtonEvents: self.delaysPrimaryMouseButtonEvents)
                }
            }
        }
        public var delaysSecondaryMouseButtonEvents: Bool = false {
            didSet {
                guard self.delaysSecondaryMouseButtonEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(delaysSecondaryMouseButtonEvents: self.delaysSecondaryMouseButtonEvents)
                }
            }
        }
        public var delaysOtherMouseButtonEvents: Bool = false {
            didSet {
                guard self.delaysOtherMouseButtonEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(delaysOtherMouseButtonEvents: self.delaysOtherMouseButtonEvents)
                }
            }
        }
        public var delaysKeyEvents: Bool = false {
            didSet {
                guard self.delaysKeyEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(delaysKeyEvents: self.delaysKeyEvents)
                }
            }
        }
        public var delaysMagnificationEvents: Bool = false {
            didSet {
                guard self.delaysMagnificationEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(delaysMagnificationEvents: self.delaysMagnificationEvents)
                }
            }
        }
        public var delaysRotationEvents: Bool = false {
            didSet {
                guard self.delaysRotationEvents != oldValue else { return }
                if self.isLoaded == true {
                    self._gesture.kk_update(delaysRotationEvents: self.delaysRotationEvents)
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

public extension UI.Gesture.Tap {
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: (() -> Void)?) -> Self {
        self.onTriggered.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: ((Self) -> Void)?) -> Self {
        self.onTriggered.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onTriggered.link(sender, closure)
        return self
    }
    
}

extension UI.Gesture.Tap : KKGestureDelegate {
    
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

extension UI.Gesture.Tap : KKTapGestureDelegate {
    
    func triggered(_ gesture: NativeGesture) {
        self.onTriggered.emit()
    }
    
}
