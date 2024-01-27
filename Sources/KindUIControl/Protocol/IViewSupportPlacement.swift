//
//  KindKit
//

import KindUI

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
    func placement(_ value: () -> Placement) -> Self {
        self.placement = value()
        return self
    }

    @inlinable
    @discardableResult
    func placement(_ value: (Self) -> Placement) -> Self {
        self.placement = value(self)
        return self
    }
    
}

public extension IViewSupportPlacement where Self : IComposite, BodyType : IViewSupportPlacement {
    
    @inlinable
    var placement: Placement {
        set { self.body.placement = newValue }
        get { self.body.placement }
    }
    
}
