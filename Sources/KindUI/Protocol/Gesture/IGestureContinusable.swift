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
    func onBegin< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onBegin.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(remove target: AnyObject) -> Self {
        self.onBegin.remove(target)
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
    func onChange< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onChange.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChange(remove target: AnyObject) -> Self {
        self.onChange.remove(target)
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
    func onCancel< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onCancel.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCancel(remove target: AnyObject) -> Self {
        self.onCancel.remove(target)
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
    func onEnd< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onEnd.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(remove target: AnyObject) -> Self {
        self.onEnd.remove(target)
        return self
    }
    
}
