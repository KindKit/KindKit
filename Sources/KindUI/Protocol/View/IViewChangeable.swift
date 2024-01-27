//
//  KindKit
//

import KindEvent

public protocol IViewChangeable : AnyObject {
    
    var onChange: Signal< Void, Void > { get }
    
}

public extension IViewChangeable where Self : IComposite, BodyType : IViewChangeable {
    
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
    
}
