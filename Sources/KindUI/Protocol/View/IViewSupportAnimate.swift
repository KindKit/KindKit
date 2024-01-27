//
//  KindKit
//

public protocol IViewSupportAnimate : AnyObject {
    
    var isAnimating: Bool { set get }
    
}

public extension IViewSupportAnimate where Self : IComposite, BodyType : IViewSupportAnimate {
    
    @inlinable
    var isAnimating: Bool {
        set { self.body.isAnimating = newValue }
        get { self.body.isAnimating }
    }
    
}

public extension IViewSupportAnimate {
    
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
    
}

public extension IViewSupportAnimate {
    
    @inlinable
    var animating: Bool {
        set { self.isAnimating = newValue }
        get { self.isAnimating }
    }
    
    @inlinable
    @discardableResult
    func animating(_ value: Bool) -> Self {
        self.animating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animating(_ value: () -> Bool) -> Self {
        return self.animating(value())
    }

    @inlinable
    @discardableResult
    func animating(_ value: (Self) -> Bool) -> Self {
        return self.animating(value(self))
    }
    
}

public extension IViewSupportAnimate {
    
    @inlinable
    @discardableResult
    func startAnimating() -> Self {
        return self.isAnimating(true)
    }
    
    @inlinable
    @discardableResult
    func endAnimating() -> Self {
        return self.isAnimating(false)
    }
    
}
