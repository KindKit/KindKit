//
//  KindKit
//

import Foundation

public protocol IUIGesture : AnyObject {
    
    var native: NativeGesture { get }
    
    var isLoaded: Bool { get }
    
    var isEnabled: Bool { set get }
    
#if os(macOS)
    
    var delaysPrimaryMouseButtonEvents: Bool { set get }
    
    var delaysSecondaryMouseButtonEvents: Bool { set get }
    
    var delaysOtherMouseButtonEvents: Bool { set get }
    
    var delaysKeyEvents: Bool { set get }
    
    var delaysMagnificationEvents: Bool { set get }
    
    var delaysRotationEvents: Bool { set get }
    
#elseif os(iOS)
    
    var cancelsTouchesInView: Bool { set get }
    
    var delaysTouchesBegan: Bool { set get }
    
    var delaysTouchesEnded: Bool { set get }
    
    var requiresExclusiveTouchType: Bool { set get }
        
#endif
    
    var onShouldBegin: Signal.Empty< Bool? > { get }
    
    var onShouldSimultaneously: Signal.Args< Bool?, NativeGesture > { get }
    
    var onShouldRequireFailure: Signal.Args< Bool?, NativeGesture > { get }
    
    var onShouldBeRequiredToFailBy: Signal.Args< Bool?, NativeGesture > { get }
    
    @discardableResult
    func enabled(_ value: Bool) -> Self
    
}

public extension IUIGesture {
    
    @discardableResult
    func enabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }


    func contains(in view: IUIView) -> Bool {
        let location = self.location(in: view)
        return view.bounds.isContains(location)
    }

    func location(in view: IUIView) -> Point {
        return Point(self.native.location(in: view.native))
    }

}

#if os(macOS)

public extension IUIGesture {
    
    @inlinable
    @discardableResult
    func delaysPrimaryMouseButtonEvents(_ value: Bool) -> Self {
        self.delaysPrimaryMouseButtonEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysSecondaryMouseButtonEvents(_ value: Bool) -> Self {
        self.delaysSecondaryMouseButtonEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysOtherMouseButtonEvents(_ value: Bool) -> Self {
        self.delaysOtherMouseButtonEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysKeyEvents(_ value: Bool) -> Self {
        self.delaysKeyEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysMagnificationEvents(_ value: Bool) -> Self {
        self.delaysMagnificationEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysRotationEvents(_ value: Bool) -> Self {
        self.delaysRotationEvents = value
        return self
    }
    
}

#elseif os(iOS)

public extension IUIGesture {
    
    @inlinable
    @discardableResult
    func cancelsTouchesInView(_ value: Bool) -> Self {
        self.cancelsTouchesInView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesBegan(_ value: Bool) -> Self {
        self.delaysTouchesBegan = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesEnded(_ value: Bool) -> Self {
        self.delaysTouchesEnded = value
        return self
    }
    
    @inlinable
    @discardableResult
    func requiresExclusiveTouchType(_ value: Bool) -> Self {
        self.requiresExclusiveTouchType = value
        return self
    }

    func require(toFail gesture: IUIGesture) {
        self.require(toFail: gesture.native)
    }

    func require(toFail gesture: NativeGesture) {
        self.native.require(toFail: gesture)
    }
    
}

#endif

public extension IUIGesture {
    
    @inlinable
    @discardableResult
    func onShouldBegin(_ closure: (() -> Bool?)?) -> Self {
        self.onShouldBegin.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin(_ closure: ((Self) -> Bool?)?) -> Self {
        self.onShouldBegin.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Bool?)?) -> Self {
        self.onShouldBegin.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: (() -> Bool?)?) -> Self {
        self.onShouldSimultaneously.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: ((Self) -> Bool?)?) -> Self {
        self.onShouldSimultaneously.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: ((NativeGesture) -> Bool?)?) -> Self {
        self.onShouldSimultaneously.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: ((Self, NativeGesture) -> Bool?)?) -> Self {
        self.onShouldSimultaneously.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Bool?)?) -> Self {
        self.onShouldSimultaneously.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, NativeGesture) -> Bool?)?) -> Self {
        self.onShouldSimultaneously.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: (() -> Bool?)?) -> Self {
        self.onShouldRequireFailure.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: ((Self) -> Bool?)?) -> Self {
        self.onShouldRequireFailure.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: ((NativeGesture) -> Bool?)?) -> Self {
        self.onShouldRequireFailure.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: ((Self, NativeGesture) -> Bool?)?) -> Self {
        self.onShouldRequireFailure.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Bool?)?) -> Self {
        self.onShouldRequireFailure.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, NativeGesture) -> Bool?)?) -> Self {
        self.onShouldRequireFailure.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: (() -> Bool?)?) -> Self {
        self.onShouldBeRequiredToFailBy.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: ((Self) -> Bool?)?) -> Self {
        self.onShouldBeRequiredToFailBy.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: ((NativeGesture) -> Bool?)?) -> Self {
        self.onShouldBeRequiredToFailBy.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: ((Self, NativeGesture) -> Bool?)?) -> Self {
        self.onShouldBeRequiredToFailBy.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Bool?)?) -> Self {
        self.onShouldBeRequiredToFailBy.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, NativeGesture) -> Bool?)?) -> Self {
        self.onShouldBeRequiredToFailBy.link(sender, closure)
        return self
    }
    
}
