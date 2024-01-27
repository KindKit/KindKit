//
//  KindKit
//

public protocol IViewSupportPlacement : AnyObject {
    
    var placement: Placement { set get }
    
}

public extension IViewSupportPlacement {
    
    @inlinable
    @discardableResult
    func placement(_ value: Placement) -> Self {
        self.placement = value
        return self
    }

    @inlinable
    @discardableResult
    func placement(on: () -> Placement) -> Self {
        self.placement = on()
        return self
    }

    @inlinable
    @discardableResult
    func placement(on: (Self) -> Placement) -> Self {
        self.placement = on(self)
        return self
    }
    
}

public extension IViewSupportPlacement where Self : CompositorTrait, Body : IViewSupportPlacement {
    
    @inlinable
    var placement: Placement {
        set { self.body.placement = newValue }
        get { self.body.placement }
    }
    
}
