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
    func shouldPressed(_ value: () -> Bool) -> Self {
        return self.shouldPressed(value())
    }

    @inlinable
    @discardableResult
    func shouldPressed(_ value: (Self) -> Bool) -> Self {
        return self.shouldPressed(value(self))
    }
    
}

public extension IUIViewPressable {
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: (() -> Void)?) -> Self {
        self.onPressed.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressed.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressed.link(sender, closure)
        return self
    }
    
}
