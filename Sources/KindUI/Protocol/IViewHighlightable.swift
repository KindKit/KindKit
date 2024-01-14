//
//  KindKit
//

public protocol IViewHighlightable : IViewStyleable {
    
    var shouldHighlighting: Bool { set get }
    
    var isHighlighted: Bool { set get }
    
}

public extension IViewHighlightable where Self : IWidgetView, Body : IViewHighlightable {
    
    @inlinable
    var shouldHighlighting: Bool {
        set { self.body.shouldHighlighting = newValue }
        get { self.body.shouldHighlighting }
    }
    
    @inlinable
    var isHighlighted: Bool {
        set { self.body.isHighlighted = newValue }
        get { self.body.isHighlighted }
    }
    
}

public extension IViewHighlightable {
    
    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self {
        self.shouldHighlighting = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: () -> Bool) -> Self {
        return self.shouldHighlighting(value())
    }

    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: (Self) -> Bool) -> Self {
        return self.shouldHighlighting(value(self))
    }
    
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
    
    @inlinable
    @discardableResult
    func highlight(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @inlinable
    @discardableResult
    func highlight(_ value: () -> Bool) -> Self {
        return self.highlight(value())
    }

    @inlinable
    @discardableResult
    func highlight(_ value: (Self) -> Bool) -> Self {
        return self.highlight(value(self))
    }
    
}
