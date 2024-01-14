//
//  KindKit
//

import KindEvent

public protocol IGestureContinusable : AnyObject {
    
    var onBegin: Signal< Void, Void > { get }
    
    var onChange: Signal< Void, Void > { get }
    
    var onCancel: Signal< Void, Void > { get }
    
    var onEnd: Signal< Void, Void > { get }
    
}

public extension IGestureContinusable {
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping () -> Void) -> Self {
        self.onBegin.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBegin.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBegin.add(sender, closure)
        return self
    }
    
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
    
    @inlinable
    @discardableResult
    func onCancel(_ closure: @escaping () -> Void) -> Self {
        self.onCancel.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel(_ closure: @escaping (Self) -> Void) -> Self {
        self.onCancel.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onCancel.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping () -> Void) -> Self {
        self.onEnd.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEnd.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEnd.add(sender, closure)
        return self
    }
    
}
