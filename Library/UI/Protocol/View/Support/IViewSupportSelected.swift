//
//  KindKit
//

import KindEvent

public protocol IViewSupportSelected : AnyObject {
    
    var isSelected: Bool { set get }
    
    var onSelected: Signal< Void, Void > { get }
    
}

public extension IViewSupportSelected {
    
    @inlinable
    @discardableResult
    func isSelected(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isSelected(on: () -> Bool) -> Self {
        self.isSelected = on()
        return self
    }

    @inlinable
    @discardableResult
    func isSelected(on: (Self) -> Bool) -> Self {
        self.isSelected = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelected(_ closure: @escaping () -> Void) -> Self {
        self.onSelected.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelected(_ closure: @escaping (Self) -> Void) -> Self {
        self.onSelected.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelected< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onSelected.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelected(remove target: AnyObject) -> Self {
        self.onSelected.remove(target)
        return self
    }
    
}

public extension IViewSupportSelected {
    
    @inlinable
    var selected: Bool {
        set { self.isSelected = newValue }
        get { self.isSelected }
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(on: () -> Bool) -> Self {
        self.isSelected = on()
        return self
    }

    @inlinable
    @discardableResult
    func selected(on: (Self) -> Bool) -> Self {
        self.isSelected = on(self)
        return self
    }
    
}

public extension IViewSupportSelected where Self : CompositorTrait, Body : IViewSupportSelected {
    
    @inlinable
    var isSelected: Bool {
        set { self.body.isSelected = newValue }
        get { self.body.isSelected }
    }
    
    @inlinable
    var onSelected: Signal< Void, Void > {
        self.body.onSelected
    }
    
}
