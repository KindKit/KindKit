//
//  KindKit
//

import Foundation

public protocol IUIViewChangeable : AnyObject {
    
    var onChange: Signal.Empty< Void > { get }
    
}

public extension IUIViewChangeable where Self : IUIWidgetView, Body : IUIViewChangeable {
    
    @inlinable
    var onChange: Signal.Empty< Void > {
        self.body.onChange
    }
    
}

public extension IUIViewChangeable {
    
    @inlinable
    @discardableResult
    func onChange(_ closure: (() -> Void)?) -> Self {
        self.onChange.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(_ closure: ((Self) -> Void)?) -> Self {
        self.onChange.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onChange.set(sender, closure)
        return self
    }
    
}
