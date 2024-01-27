//
//  KindKit
//

public protocol IViewSelectable : AnyObject {
    
    var isSelected: Bool { set get }
    
}

public extension IViewSelectable where Self : IComposite, BodyType : IViewSelectable {
    
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
    
}

public extension IViewSelectable {
    
    @inlinable
    var selected: Bool {
        set { self.isSelected = newValue }
        get { self.isSelected }
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: () -> Bool) -> Self {
        self.isSelected = value()
        return self
    }

    @inlinable
    @discardableResult
    func selected(_ value: (Self) -> Bool) -> Self {
        self.isSelected = value(self)
        return self
    }
    
}
