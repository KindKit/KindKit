//
//  KindKit
//

import KindEvent

public protocol IViewSupportHighlighted : AnyObject {
    
    var isHighlighted: Bool { set get }
    
    var onHighlighted: Signal< Void, Void > { get }
    
}

public extension IViewSupportHighlighted {
    
    @inlinable
    @discardableResult
    func isHighlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isHighlighted(on: () -> Bool) -> Self {
        self.isHighlighted = on()
        return self
    }

    @inlinable
    @discardableResult
    func isHighlighted(on: (Self) -> Bool) -> Self {
        self.isHighlighted = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHighlighted(_ closure: @escaping () -> Void) -> Self {
        self.onHighlighted.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHighlighted(_ closure: @escaping (Self) -> Void) -> Self {
        self.onHighlighted.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHighlighted< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onHighlighted.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHighlighted(remove target: AnyObject) -> Self {
        self.onHighlighted.remove(target)
        return self
    }
    
}

public extension IViewSupportHighlighted {
    
    @inlinable
    var highlighted: Bool {
        set { self.isHighlighted = newValue }
        get { self.isHighlighted }
    }
    
    @inlinable
    @discardableResult
    func highlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @inlinable
    @discardableResult
    func highlighted(on: () -> Bool) -> Self {
        self.isHighlighted = on()
        return self
    }

    @inlinable
    @discardableResult
    func highlighted(on: (Self) -> Bool) -> Self {
        self.isHighlighted = on(self)
        return self
    }
    
}

public extension IViewSupportHighlighted where Self : CompositorTrait, Body : IViewSupportHighlighted {
    
    @inlinable
    var isHighlighted: Bool {
        set { self.body.isHighlighted = newValue }
        get { self.body.isHighlighted }
    }
    
    @inlinable
    var onHighlighted: Signal< Void, Void > {
        self.body.onHighlighted
    }
    
}
