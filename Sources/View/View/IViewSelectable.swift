//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewSelectable : IViewStyleable {
    
    var isSelected: Bool { set get }
    
}

public extension IViewSelectable {
    
    @inlinable
    @discardableResult
    func select(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewSelectable {
    
    @inlinable
    var isSelected: Bool {
        set(value) { self.body.isSelected = value }
        get { return self.body.isSelected }
    }
    
    @inlinable
    @discardableResult
    func select(_ value: Bool) -> Self {
        self.body.select(value)
        return self
    }
    
}
