//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewLockable : IViewStyleable {
    
    var isLocked: Bool { set get }
    
}

public extension IViewLockable {
    
    @inlinable
    @discardableResult
    func lock(_ value: Bool) -> Self {
        self.isLocked = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewLockable {
    
    @inlinable
    var isLocked: Bool {
        set(value) { self.body.isLocked = value }
        get { return self.body.isLocked }
    }
    
    @inlinable
    @discardableResult
    func lock(_ value: Bool) -> Self {
        self.body.lock(value)
        return self
    }
    
}
