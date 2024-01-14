//
//  KindKit
//

public protocol IViewSelectable : IViewStyleable {
    
    var isSelected: Bool { set get }
    
}

public extension IViewSelectable where Self : IWidgetView, Body : IViewSelectable {
    
    @inlinable
    var isSelected: Bool {
        set { self.body.isSelected = newValue }
        get { self.body.isSelected }
    }
    
}

public extension IViewSelectable {
    
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
