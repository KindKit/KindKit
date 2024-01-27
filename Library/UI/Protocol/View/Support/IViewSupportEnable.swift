//
//  KindKit
//

import KindEvent

public protocol IViewSupportEnable : AnyObject {
    
    var isEnabled: Bool { set get }
    
    var onEnabled: Signal< Void, Void > { get }
    
}

public extension IViewSupportEnable {
    
    @inlinable
    @discardableResult
    func isEnabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isEnabled(on: () -> Bool) -> Self {
        self.isEnabled = on()
        return self
    }

    @inlinable
    @discardableResult
    func isEnabled(on: (Self) -> Bool) -> Self {
        self.isEnabled = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnabled(_ closure: @escaping () -> Void) -> Self {
        self.onEnabled.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnabled(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEnabled.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnabled< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onEnabled.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnabled(remove target: AnyObject) -> Self {
        self.onEnabled.remove(target)
        return self
    }
    
}

public extension IViewSupportEnable {
    
    @inlinable
    var isDisabled: Bool {
        set { self.isEnabled = !newValue }
        get { !self.isEnabled }
    }
    
    @inlinable
    @discardableResult
    func isDisabled(_ value: Bool) -> Self {
        self.isDisabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isDisabled(on: () -> Bool) -> Self {
        self.isDisabled = on()
        return self
    }

    @inlinable
    @discardableResult
    func isDisabled(on: (Self) -> Bool) -> Self {
        self.isDisabled = on(self)
        return self
    }
    
}

public extension IViewSupportEnable {
    
    @inlinable
    var enabled: Bool {
        set { self.isEnabled = newValue }
        get { self.isEnabled }
    }
    
    @inlinable
    @discardableResult
    func enabled(_ value: Bool) -> Self {
        self.enabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func enabled(on: () -> Bool) -> Self {
        self.enabled = on()
        return self
    }

    @inlinable
    @discardableResult
    func locked(on: (Self) -> Bool) -> Self {
        self.enabled = on(self)
        return self
    }
    
}

public extension IViewSupportEnable {
    
    @inlinable
    var disabled: Bool {
        set { self.isEnabled = !newValue }
        get { !self.isEnabled }
    }
    
    @inlinable
    @discardableResult
    func disabled(_ value: Bool) -> Self {
        self.disabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func disabled(on: () -> Bool) -> Self {
        self.disabled = on()
        return self
    }

    @inlinable
    @discardableResult
    func disabled(on: (Self) -> Bool) -> Self {
        self.disabled = on(self)
        return self
    }
    
}

public extension IViewSupportEnable where Self : CompositorTrait, Body : IViewSupportEnable {
    
    @inlinable
    var isEnabled: Bool {
        set { self.body.isEnabled = newValue }
        get { self.body.isEnabled }
    }
    
    @inlinable
    var onEnabled: Signal< Void, Void > {
        self.body.onEnabled
    }
    
}
