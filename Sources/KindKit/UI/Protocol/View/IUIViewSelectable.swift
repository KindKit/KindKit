//
//  KindKit
//

import Foundation

public protocol IUIViewSelectable : IUIViewStyleable {
    
    var isSelected: Bool { set get }
    
}

public extension IUIViewSelectable where Self : IUIWidgetView, Body : IUIViewSelectable {
    
    @inlinable
    var isSelected: Bool {
        set { self.body.isSelected = newValue }
        get { self.body.isSelected }
    }
    
}

public extension IUIViewSelectable {
    
    @inlinable
    @discardableResult
    func isSelected(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isSelected(_ value: () -> Bool) -> Self {
        return self.isSelected(value())
    }

    @inlinable
    @discardableResult
    func isSelected(_ value: (Self) -> Bool) -> Self {
        return self.isSelected(value(self))
    }
    
    @inlinable
    @discardableResult
    func select(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func select(_ value: () -> Bool) -> Self {
        return self.select(value())
    }

    @inlinable
    @discardableResult
    func select(_ value: (Self) -> Bool) -> Self {
        return self.select(value(self))
    }
    
}
