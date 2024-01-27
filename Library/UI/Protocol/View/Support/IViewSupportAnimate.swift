//
//  KindKit
//

public protocol IViewSupportAnimate : AnyObject {
    
    var isAnimating: Bool { set get }
    
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
    func isAnimating(on: () -> Bool) -> Self {
        self.isAnimating = on()
        return self
    }

    @inlinable
    @discardableResult
    func isAnimating(on: (Self) -> Bool) -> Self {
        self.isAnimating = on(self)
        return self
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
    func animating(on: () -> Bool) -> Self {
        self.animating = on()
        return self
    }

    @inlinable
    @discardableResult
    func animating(on: (Self) -> Bool) -> Self {
        self.animating = on(self)
        return self
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

public extension IViewSupportAnimate where Self : CompositorTrait, Body : IViewSupportAnimate {
    
    @inlinable
    var isAnimating: Bool {
        set { self.body.isAnimating = newValue }
        get { self.body.isAnimating }
    }
    
}
