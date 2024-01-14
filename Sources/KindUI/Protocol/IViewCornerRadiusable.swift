//
//  KindKit
//

import KindGraphics

public protocol IViewCornerRadiusable : AnyObject {
    
    var cornerRadius: CornerRadius { set get }
    
}

public extension IViewCornerRadiusable where Self : IWidgetView, Body : IViewCornerRadiusable {
    
    @inlinable
    var cornerRadius: CornerRadius {
        set { self.body.cornerRadius = newValue }
        get { self.body.cornerRadius }
    }
    
}

public extension IViewCornerRadiusable {
    
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
