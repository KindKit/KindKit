//
//  KindKit
//

import Foundation

public protocol IUIViewLockable : IUIViewStyleable {
    
    var isLocked: Bool { set get }
    
}

public extension IUIViewLockable where Self : IUIWidgetView, Body : IUIViewLockable {
    
    @inlinable
    var isLocked: Bool {
        set { self.body.isLocked = newValue }
        get { self.body.isLocked }
    }
    
}

public extension IUIViewLockable {
    
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
