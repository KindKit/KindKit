//
//  KindKit
//

public protocol IViewAnimatable : AnyObject {
    
    var isAnimating: Bool { set get }
    
}

public extension IViewAnimatable where Self : IWidgetView, Body : IViewAnimatable {
    
    @inlinable
    var isAnimating: Bool {
        set { self.body.isAnimating = newValue }
        get { self.body.isAnimating }
    }
    
}

public extension IViewAnimatable {
    
    @inlinable
    @discardableResult
    func isAnimating(_ value: Bool) -> Self {
        self.isAnimating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isAnimating(_ value: () -> Bool) -> Self {
        return self.isAnimating(value())
    }

    @inlinable
    @discardableResult
    func isAnimating(_ value: (Self) -> Bool) -> Self {
        return self.isAnimating(value(self))
    }
    
    @inlinable
    @discardableResult
    func animate(_ value: Bool) -> Self {
        self.isAnimating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animate(_ value: () -> Bool) -> Self {
        return self.animate(value())
    }

    @inlinable
    @discardableResult
    func animate(_ value: (Self) -> Bool) -> Self {
        return self.animate(value(self))
    }
    
}
