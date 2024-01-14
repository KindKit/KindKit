//
//  KindKit
//

import KindEvent

public protocol IViewChangeable : AnyObject {
    
    var onChange: Signal< Void, Void > { get }
    
}

public extension IViewChangeable where Self : IWidgetView, Body : IViewChangeable {
    
    @inlinable
    var onChange: Signal< Void, Void > {
        self.body.onChange
    }
    
}

public extension IViewChangeable {
    
    @inlinable
    @discardableResult
    func onChange(_ closure: @escaping () -> Void) -> Self {
        self.onChange.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(_ closure: @escaping (Self) -> Void) -> Self {
        self.onChange.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onChange.add(sender, closure)
        return self
    }
    
}
