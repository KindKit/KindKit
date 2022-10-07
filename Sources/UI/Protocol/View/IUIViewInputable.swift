//
//  KindKit
//

import Foundation

public protocol IUIViewInputable : AnyObject {
    
    var isEditing: Bool { get }
    
    var onBeginEditing: Signal.Empty< Void > { get }
    
    var onEditing: Signal.Empty< Void > { get }
    
    var onEndEditing: Signal.Empty< Void > { get }
    
    @discardableResult
    func startEditing() -> Self
    
    @discardableResult
    func endEditing() -> Self
    
}

public extension IUIViewInputable where Self : IUIWidgetView, Body : IUIViewInputable {
    
    @inlinable
    var isEditing: Bool {
        self.body.isEditing
    }
    
    @inlinable
    var onBeginEditing: Signal.Empty< Void > {
        self.body.onBeginEditing
    }
    
    @inlinable
    var onEditing: Signal.Empty< Void > {
        self.body.onBeginEditing
    }
    
    @inlinable
    var onEndEditing: Signal.Empty< Void > {
        self.body.onBeginEditing
    }
    
    @discardableResult
    func startEditing() -> Self {
        self.body.startEditing()
        return self
    }
    
    @discardableResult
    func endEditing() -> Self {
        self.body.endEditing()
        return self
    }
    
}

public extension IUIViewInputable {
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: (() -> Void)?) -> Self {
        self.onBeginEditing.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: ((Self) -> Void)?) -> Self {
        self.onBeginEditing.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onBeginEditing.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ closure: (() -> Void)?) -> Self {
        self.onEditing.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ closure: ((Self) -> Void)?) -> Self {
        self.onEditing.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onEditing.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: (() -> Void)?) -> Self {
        self.onEndEditing.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: ((Self) -> Void)?) -> Self {
        self.onEndEditing.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onEndEditing.set(sender, closure)
        return self
    }
    
}
