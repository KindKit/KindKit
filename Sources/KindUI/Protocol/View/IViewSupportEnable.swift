//
//  KindKit
//

public protocol IViewSupportEnable : AnyObject {
    
    var isEnabled: Bool { set get }
    
}

public extension IViewSupportEnable where Self : IComposite, BodyType : IViewSupportEnable {
    
    @inlinable
    var isEnabled: Bool {
        set { self.body.isEnabled = newValue }
        get { self.body.isEnabled }
    }
    
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
    func isEnabled(_ value: () -> Bool) -> Self {
        self.isEnabled = value()
        return self
    }

    @inlinable
    @discardableResult
    func isEnabled(_ value: (Self) -> Bool) -> Self {
        self.isEnabled = value(self)
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
    func isDisabled(_ value: () -> Bool) -> Self {
        self.isDisabled = value()
        return self
    }

    @inlinable
    @discardableResult
    func isDisabled(_ value: (Self) -> Bool) -> Self {
        self.isDisabled = value(self)
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
    func enabled(_ value: () -> Bool) -> Self {
        self.enabled = value()
        return self
    }

    @inlinable
    @discardableResult
    func locked(_ value: (Self) -> Bool) -> Self {
        self.enabled = value(self)
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
    func disabled(_ value: () -> Bool) -> Self {
        self.disabled = value()
        return self
    }

    @inlinable
    @discardableResult
    func disabled(_ value: (Self) -> Bool) -> Self {
        self.disabled = value(self)
        return self
    }
    
}
