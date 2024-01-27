//
//  KindKit
//

public protocol IViewSupportAlpha : AnyObject {
    
    var alpha: Double { set get }
    
}

public extension IViewSupportAlpha {
    
    @inlinable
    @discardableResult
    func alpha(_ value: Double) -> Self {
        self.alpha = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alpha(on: () -> Double) -> Self {
        self.alpha = on()
        return self
    }

    @inlinable
    @discardableResult
    func alpha(on: (Self) -> Double) -> Self {
        self.alpha = on(self)
        return self
    }
    
}

public extension IViewSupportAlpha where Self : CompositorTrait, Body : IViewSupportAlpha {
    
    @inlinable
    var alpha: Double {
        set { self.body.alpha = newValue }
        get { self.body.alpha }
    }
    
}
