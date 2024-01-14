//
//  KindKit
//

import KindEvent

public protocol IViewPressable : AnyObject {
    
    var shouldPressed: Bool { set get }
    
    var onPressed: Signal< Void, Void > { get }
    
}

public extension IViewPressable where Self : IWidgetView, Body : IViewPressable {
    
    @inlinable
    var shouldPressed: Bool {
        set { self.body.shouldPressed = newValue }
        get { self.body.shouldPressed }
    }
    
    @inlinable
    var onPressed: Signal< Void, Void > {
        self.body.onPressed
    }
    
}

public extension IViewPressable {
    
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

public extension IViewPressable {
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping () -> Void) -> Self {
        self.onPressed.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressed.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressed.add(sender, closure)
        return self
    }
    
}
