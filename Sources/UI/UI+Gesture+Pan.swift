//
//  KindKit
//

import Foundation

#if os(iOS)

protocol KKPanGestureDelegate : KKGestureDelegate {
    
    func begin(_ gesture: NativeGesture)
    func changed(_ gesture: NativeGesture)
    func cancel(_ gesture: NativeGesture)
    func end(_ gesture: NativeGesture)
    
}

public extension UI.Gesture {
    
    final class Pan : IUIGesture {
        
        public var native: NativeGesture {
            return self._gesture
        }
        public var isLoaded: Bool {
            return self._reuse.isLoaded
        }
        public var isEnabled: Bool = true {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(enabled: self.isEnabled)
            }
        }
#if os(macOS)
        public var delaysPrimaryMouseButtonEvents: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysPrimaryMouseButtonEvents: self.delaysPrimaryMouseButtonEvents)
            }
        }
        public var delaysSecondaryMouseButtonEvents: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysSecondaryMouseButtonEvents: self.delaysSecondaryMouseButtonEvents)
            }
        }
        public var delaysOtherMouseButtonEvents: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysOtherMouseButtonEvents: self.delaysOtherMouseButtonEvents)
            }
        }
        public var delaysKeyEvents: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysKeyEvents: self.delaysKeyEvents)
            }
        }
        public var delaysMagnificationEvents: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysMagnificationEvents: self.delaysMagnificationEvents)
            }
        }
        public var delaysRotationEvents: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysRotationEvents: self.delaysRotationEvents)
            }
        }
#elseif os(iOS)
        public var cancelsTouchesInView: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(cancelsTouchesInView: self.cancelsTouchesInView)
            }
        }
        public var delaysTouchesBegan: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysTouchesBegan: self.delaysTouchesBegan)
            }
        }
        public var delaysTouchesEnded: Bool = true {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(delaysTouchesEnded: self.delaysTouchesEnded)
            }
        }
        public var requiresExclusiveTouchType: Bool = true {
            didSet {
                guard self.isLoaded == true else { return }
                self._gesture.update(requiresExclusiveTouchType: self.requiresExclusiveTouchType)
            }
        }
#endif
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _gesture: Reusable.Content {
            return self._reuse.content
        }
        private var _onShouldBegin: ((UI.Gesture.Pan) -> Bool)?
        private var _onShouldSimultaneously: ((UI.Gesture.Pan, NativeGesture) -> Bool)?
        private var _onShouldRequireFailure: ((UI.Gesture.Pan, NativeGesture) -> Bool)?
        private var _onShouldBeRequiredToFailBy: ((UI.Gesture.Pan, NativeGesture) -> Bool)?
        private var _onBegin: ((UI.Gesture.Pan) -> Void)?
        private var _onChange: ((UI.Gesture.Pan) -> Void)?
        private var _onCancel: ((UI.Gesture.Pan) -> Void)?
        private var _onEnd: ((UI.Gesture.Pan) -> Void)?

        public init() {
            self._reuse = UI.Reuse.Item(unloadBehaviour: .whenDestroy)
            self._reuse.configure(owner: self)
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
                
        @discardableResult
        public func onShouldBegin(_ value: ((UI.Gesture.Pan) -> Bool)?) -> Self {
            self._onShouldBegin = value
            return self
        }
        
        @discardableResult
        public func onShouldSimultaneously(_ value: ((UI.Gesture.Pan, NativeGesture) -> Bool)?) -> Self {
            self._onShouldSimultaneously = value
            return self
        }
        
        @discardableResult
        public func onShouldRequireFailure(_ value: ((UI.Gesture.Pan, NativeGesture) -> Bool)?) -> Self {
            self._onShouldRequireFailure = value
            return self
        }
        
        @discardableResult
        public func onShouldBeRequiredToFailBy(_ value: ((UI.Gesture.Pan, NativeGesture) -> Bool)?) -> Self {
            self._onShouldBeRequiredToFailBy = value
            return self
        }
        
        @discardableResult
        public func onBegin(_ value: ((UI.Gesture.Pan) -> Void)?) -> Self {
            self._onBegin = value
            return self
        }
        
        @discardableResult
        public func onChange(_ value: ((UI.Gesture.Pan) -> Void)?) -> Self {
            self._onChange = value
            return self
        }
        
        @discardableResult
        public func onCancel(_ value: ((UI.Gesture.Pan) -> Void)?) -> Self {
            self._onCancel = value
            return self
        }
        
        @discardableResult
        public func onEnd(_ value: ((UI.Gesture.Pan) -> Void)?) -> Self {
            self._onEnd = value
            return self
        }
        
    }
    
}

extension UI.Gesture.Pan : KKGestureDelegate {
    
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

extension UI.Gesture.Pan : KKPanGestureDelegate {
    
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
