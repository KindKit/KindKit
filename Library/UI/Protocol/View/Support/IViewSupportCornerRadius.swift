//
//  KindKit
//

import KindGraphics

public protocol IViewSupportCornerRadius : AnyObject {
    
    var cornerRadius: CornerRadius { set get }
    
}

public extension IViewSupportCornerRadius {
    
    @inlinable
    @discardableResult
    func cornerRadius(_ value: CornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
    @inlinable
    @discardableResult
    func cornerRadius(on: () -> CornerRadius) -> Self {
        self.cornerRadius = on()
        return self
    }

    @inlinable
    @discardableResult
    func cornerRadius(on: (Self) -> CornerRadius) -> Self {
        self.cornerRadius = on(self)
        return self
    }
    
}

public extension IViewSupportCornerRadius where Self : CompositorTrait, Body : IViewSupportCornerRadius {
    
    @inlinable
    var cornerRadius: CornerRadius {
        set { self.body.cornerRadius = newValue }
        get { self.body.cornerRadius }
    }
    
}
