//
//  KindKit
//

import KindGraphics

public protocol IViewShadowable : AnyObject {
    
    var shadow: Shadow? { set get }
    
}

public extension IViewShadowable where Self : IWidgetView, Body : IViewShadowable {
    
    @inlinable
    var shadow: Shadow? {
        set { self.body.shadow = newValue }
        get { self.body.shadow }
    }
    
}

public extension IViewShadowable {
    
    @inlinable
    @discardableResult
    func shadow(_ value: Shadow?) -> Self {
        self.shadow = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shadow(_ value: () -> Shadow?) -> Self {
        return self.shadow(value())
    }

    @inlinable
    @discardableResult
    func shadow(_ value: (Self) -> Shadow?) -> Self {
        return self.shadow(value(self))
    }
    
}
