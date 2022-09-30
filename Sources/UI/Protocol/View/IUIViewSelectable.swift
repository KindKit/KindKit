//
//  KindKit
//

import Foundation

public protocol IUIViewSelectable : IUIViewStyleable {
    
    var isSelected: Bool { set get }
    
}

public extension IUIViewSelectable {
    
    @inlinable
    @discardableResult
    func select(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
}

public extension IUIViewSelectable where Self : IUIWidgetView, Body : IUIViewSelectable {
    
    @inlinable
    var isSelected: Bool {
        set { self.body.isSelected = newValue }
        get { return self.body.isSelected }
    }
    
}
