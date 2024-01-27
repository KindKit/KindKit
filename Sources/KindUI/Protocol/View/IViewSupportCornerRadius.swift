//
//  KindKit
//

import KindGraphics

public protocol IViewSupportCornerRadius : AnyObject {
    
    var cornerRadius: CornerRadius { set get }
    
}

public extension IViewSupportCornerRadius where Self : IComposite, BodyType : IViewSupportCornerRadius {
    
    @inlinable
    var cornerRadius: CornerRadius {
        set { self.body.cornerRadius = newValue }
        get { self.body.cornerRadius }
    }
    
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
    func cornerRadius(_ value: () -> CornerRadius) -> Self {
        return self.cornerRadius(value())
    }

    @inlinable
    @discardableResult
    func cornerRadius(_ value: (Self) -> CornerRadius) -> Self {
        return self.cornerRadius(value(self))
    }
    
}
