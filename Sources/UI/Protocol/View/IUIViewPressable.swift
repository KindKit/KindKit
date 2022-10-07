//
//  KindKit
//

import Foundation

public protocol IUIViewPressable : AnyObject {
    
    var shouldPressed: Bool { set get }
    
    var onPressed: Signal.Empty< Void > { get }
    
}

public extension IUIViewPressable where Self : IUIWidgetView, Body : IUIViewPressable {
    
    @inlinable
    var shouldPressed: Bool {
        set { self.body.shouldPressed = newValue }
        get { self.body.shouldPressed }
    }
    
    @inlinable
    var onPressed: Signal.Empty< Void > {
        self.body.onPressed
    }
    
}

public extension IUIViewPressable {
    
    @inlinable
    @discardableResult
    func shouldPressed(_ value: Bool) -> Self {
        self.shouldPressed = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: (() -> Void)?) -> Self {
        self.onPressed.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: ((Self) -> Void)?) -> Self {
        self.onPressed.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onPressed.set(sender, closure)
        return self
    }
    
}
