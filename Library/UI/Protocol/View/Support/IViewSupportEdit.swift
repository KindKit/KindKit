//
//  KindKit
//

import KindEvent

public protocol IViewSupportEdit : AnyObject {
    
    var shouldEditing: Bool { set get }
    
    var isEditing: Bool { set get }
    
    var onBeginEditing: Signal< Void, Void > { get }
    
    var onEndEditing: Signal< Void, Void > { get }
    
}

public extension IViewSupportEdit {
    
    @inlinable
    @discardableResult
    func shouldEditing(_ value: Bool) -> Self {
        self.shouldEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldEditing(on: () -> Bool) -> Self {
        self.shouldEditing = on()
        return self
    }

    @inlinable
    @discardableResult
    func shouldEditing(on: (Self) -> Bool) -> Self {
        self.shouldEditing = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func isEditing(_ value: Bool) -> Self {
        self.isEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isEditing(on: () -> Bool) -> Self {
        self.isEditing = on()
        return self
    }

    @inlinable
    @discardableResult
    func isEditing(on: (Self) -> Bool) -> Self {
        self.isEditing = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: @escaping () -> Void) -> Self {
        self.onBeginEditing.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginEditing.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onBeginEditing.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(remove target: AnyObject) -> Self {
        self.onBeginEditing.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: @escaping () -> Void) -> Self {
        self.onEndEditing.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndEditing.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onEndEditing.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(remove target: AnyObject) -> Self {
        self.onEndEditing.remove(target)
        return self
    }
    
}

public extension IViewSupportEdit {
    
    @inlinable
    var editing: Bool {
        set { self.isEditing = newValue }
        get { self.isEditing }
    }
    
    @inlinable
    @discardableResult
    func editing(_ value: Bool) -> Self {
        self.editing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func editing(on: () -> Bool) -> Self {
        self.editing = on()
        return self
    }

    @inlinable
    @discardableResult
    func editing(on: (Self) -> Bool) -> Self {
        self.editing = on(self)
        return self
    }
    
}

public extension IViewSupportEdit {
    
    @inlinable
    @discardableResult
    func startEditing() -> Self {
        return self.isEditing(true)
    }
    
    @inlinable
    @discardableResult
    func endEditing() -> Self {
        return self.isEditing(false)
    }
    
}

public extension IViewSupportEdit where Self : CompositorTrait, Body : IViewSupportEdit {
    
    @inlinable
    var shouldEditing: Bool {
        set { self.body.shouldEditing = newValue }
        get { self.body.shouldEditing }
    }
    
    @inlinable
    var isEditing: Bool {
        set { self.body.isEditing = newValue }
        get { self.body.isEditing }
    }
    
    @inlinable
    var onBeginEditing: Signal< Void, Void > {
        self.body.onBeginEditing
    }
    
    @inlinable
    var onEndEditing: Signal< Void, Void > {
        self.body.onEndEditing
    }
    
}
