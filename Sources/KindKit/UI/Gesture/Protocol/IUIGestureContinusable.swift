//
//  KindKit
//

import Foundation

public protocol IUIGestureContinusable : AnyObject {
    
    var onBegin: Signal.Empty< Void > { get }
    
    var onChange: Signal.Empty< Void > { get }
    
    var onCancel: Signal.Empty< Void > { get }
    
    var onEnd: Signal.Empty< Void > { get }
    
}

public extension IUIGestureContinusable {
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: (() -> Void)?) -> Self {
        self.onBegin.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBegin.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBegin.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(_ closure: (() -> Void)?) -> Self {
        self.onChange.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(_ closure: @escaping (Self) -> Void) -> Self {
        self.onChange.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onChange.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel(_ closure: (() -> Void)?) -> Self {
        self.onCancel.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel(_ closure: @escaping (Self) -> Void) -> Self {
        self.onCancel.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onCancel.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: (() -> Void)?) -> Self {
        self.onEnd.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEnd.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEnd.link(sender, closure)
        return self
    }
    
}
