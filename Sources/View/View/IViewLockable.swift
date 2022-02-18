//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewLockable : IViewStyleable {
    
    var isLocked: Bool { set get }
    
    @discardableResult
    func lock(_ value: Bool) -> Self
    
}

extension IWidgetView where Body : IViewLockable {
    
    public var isLocked: Bool {
        set(value) { self.body.isLocked = value }
        get { return self.body.isLocked }
    }
    
    @discardableResult
    public func lock(_ value: Bool) -> Self {
        self.body.lock(value)
        return self
    }
    
}
