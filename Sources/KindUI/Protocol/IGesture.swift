//
//  KindKit
//

import KindEvent
import KindMath

public protocol IGesture : AnyObject {
    
    var native: NativeGesture { get }
    
    var isLoaded: Bool { get }
    
    var isEnabled: Bool { set get }
    
#if os(iOS)
    
    var cancelsTouchesInView: Bool { set get }
    
    var delaysTouchesBegan: Bool { set get }
    
    var delaysTouchesEnded: Bool { set get }
    
    var requiresExclusiveTouchType: Bool { set get }
        
#endif
    
    var onShouldBegin: Signal< Bool?, Void > { get }
    
    var onShouldSimultaneously: Signal< Bool?, NativeGesture > { get }
    
    var onShouldRequireFailure: Signal< Bool?, NativeGesture > { get }
    
    var onShouldBeRequiredToFailBy: Signal< Bool?, NativeGesture > { get }
    
}

public extension IGesture {

    func contains(
        in view: IView,
        inset: Inset = .zero
    ) -> Bool {
        let location = self.location(in: view)
        let bounds = view.bounds.inset(-inset)
        return bounds.isContains(location)
    }

    func location(in view: IView) -> Point {
        return Point(self.native.location(in: view.native))
    }

}

public extension IGesture {
    
    @discardableResult
    func enabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }
    
    @discardableResult
    func enabled(_ value: (Self) -> Bool) -> Self {
        return self.enabled(value(self))
    }
    
}

#if os(iOS)

public extension IGesture {
    
    func require(toFail gesture: IGesture) {
        self.require(toFail: gesture.native)
    }
    
    func require(toFail gesture: NativeGesture) {
        self.native.require(toFail: gesture)
    }
    
}

public extension IGesture {
    
    @inlinable
    @discardableResult
    func cancelsTouchesInView(_ value: Bool) -> Self {
        self.cancelsTouchesInView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func cancelsTouchesInView(_ value: () -> Bool) -> Self {
        return self.cancelsTouchesInView(value())
    }

    @inlinable
    @discardableResult
    func cancelsTouchesInView(_ value: (Self) -> Bool) -> Self {
        return self.cancelsTouchesInView(value(self))
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesBegan(_ value: Bool) -> Self {
        self.delaysTouchesBegan = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesBegan(_ value: () -> Bool) -> Self {
        return self.delaysTouchesBegan(value())
    }

    @inlinable
    @discardableResult
    func delaysTouchesBegan(_ value: (Self) -> Bool) -> Self {
        return self.delaysTouchesBegan(value(self))
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesEnded(_ value: Bool) -> Self {
        self.delaysTouchesEnded = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesEnded(_ value: () -> Bool) -> Self {
        return self.delaysTouchesEnded(value())
    }

    @inlinable
    @discardableResult
    func delaysTouchesEnded(_ value: (Self) -> Bool) -> Self {
        return self.delaysTouchesEnded(value(self))
    }
    
    @inlinable
    @discardableResult
    func requiresExclusiveTouchType(_ value: Bool) -> Self {
        self.requiresExclusiveTouchType = value
        return self
    }
    
    @inlinable
    @discardableResult
    func requiresExclusiveTouchType(_ value: () -> Bool) -> Self {
        return self.requiresExclusiveTouchType(value())
    }

    @inlinable
    @discardableResult
    func requiresExclusiveTouchType(_ value: (Self) -> Bool) -> Self {
        return self.requiresExclusiveTouchType(value(self))
    }
    
}

#endif

public extension IGesture {
    
    @inlinable
    @discardableResult
    func onShouldBegin(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldBegin.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldBegin.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool?) -> Self {
        self.onShouldBegin.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldSimultaneously.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping (NativeGesture) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping (Self, NativeGesture) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NativeGesture) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldRequireFailure.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping (NativeGesture) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping (Self, NativeGesture) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NativeGesture) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping (NativeGesture) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping (Self, NativeGesture) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NativeGesture) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(sender, closure)
        return self
    }
    
}
