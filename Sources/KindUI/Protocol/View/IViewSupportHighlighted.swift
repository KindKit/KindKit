//
//  KindKit
//

public protocol IViewSupportHighlighted : AnyObject {
    
    var isHighlighted: Bool { set get }
    
}

public extension IViewSupportHighlighted where Self : IComposite, BodyType : IViewSupportHighlighted {
    
    @inlinable
    var isHighlighted: Bool {
        set { self.body.isHighlighted = newValue }
        get { self.body.isHighlighted }
    }
    
}

public extension IViewSupportHighlighted {
    
    @inlinable
    @discardableResult
    func isHighlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isHighlighted(_ value: () -> Bool) -> Self {
        return self.isHighlighted(value())
    }

    @inlinable
    @discardableResult
    func isHighlighted(_ value: (Self) -> Bool) -> Self {
        return self.isHighlighted(value(self))
    }
    
}

public extension IViewSupportHighlighted {
    
    @inlinable
    var highlighted: Bool {
        set { self.isHighlighted = newValue }
        get { self.isHighlighted }
    }
    
    @inlinable
    @discardableResult
    func highlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @inlinable
    @discardableResult
    func highlighted(_ value: () -> Bool) -> Self {
        self.isHighlighted = value()
        return self
    }

    @inlinable
    @discardableResult
    func highlighted(_ value: (Self) -> Bool) -> Self {
        self.isHighlighted = value(self)
        return self
    }
    
}
