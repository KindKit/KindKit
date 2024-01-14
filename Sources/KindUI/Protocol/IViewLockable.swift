//
//  KindKit
//

public protocol IViewLockable : IViewStyleable {
    
    var isLocked: Bool { set get }
    
}

public extension IViewLockable where Self : IWidgetView, Body : IViewLockable {
    
    @inlinable
    var isLocked: Bool {
        set { self.body.isLocked = newValue }
        get { self.body.isLocked }
    }
    
}

public extension IViewLockable {
    
    @inlinable
    var locked: Bool {
        set { self.isLocked = newValue }
        get { self.isLocked }
    }
    
    @inlinable
    @discardableResult
    func isLocked(_ value: Bool) -> Self {
        self.isLocked = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isLocked(_ value: () -> Bool) -> Self {
        return self.isLocked(value())
    }

    @inlinable
    @discardableResult
    func isLocked(_ value: (Self) -> Bool) -> Self {
        return self.isLocked(value(self))
    }
    
    @inlinable
    @discardableResult
    func lock(_ value: Bool) -> Self {
        self.isLocked = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lock(_ value: () -> Bool) -> Self {
        return self.lock(value())
    }

    @inlinable
    @discardableResult
    func lock(_ value: (Self) -> Bool) -> Self {
        return self.lock(value(self))
    }
    
}
