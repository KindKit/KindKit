//
//  KindKit
//

import Foundation

public protocol IUIViewLockable : IUIViewStyleable {
    
    var isLocked: Bool { set get }
    
}

public extension IUIViewLockable {
    
    @inlinable
    @discardableResult
    func locked(_ value: Bool) -> Self {
        self.isLocked = value
        return self
    }
    
}

public extension IUIViewLockable where Self : IUIWidgetView, Body : IUIViewLockable {
    
    @inlinable
    var isLocked: Bool {
        set(value) { self.body.isLocked = value }
        get { return self.body.isLocked }
    }
    
}
