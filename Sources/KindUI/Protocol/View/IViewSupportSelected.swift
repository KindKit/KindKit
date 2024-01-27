//
//  KindKit
//

public protocol IViewSupportSelected : AnyObject {
    
    var isSelected: Bool { set get }
    
}

public extension IViewSupportSelected where Self : IComposite, BodyType : IViewSupportSelected {
    
    @inlinable
    var isSelected: Bool {
        set { self.body.isSelected = newValue }
        get { self.body.isSelected }
    }
    
}

public extension IViewSupportSelected {
    
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

public extension IViewSupportSelected {
    
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
