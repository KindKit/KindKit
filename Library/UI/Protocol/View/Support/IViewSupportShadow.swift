//
//  KindKit
//

import KindGraphics

public protocol IViewSupportShadow : AnyObject {
    
    var shadow: Shadow? { set get }
    
}

public extension IViewSupportShadow {
    
    @inlinable
    @discardableResult
    func shadow(_ value: Shadow?) -> Self {
        self.shadow = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shadow(on: () -> Shadow?) -> Self {
        self.shadow = on()
        return self
    }

    @inlinable
    @discardableResult
    func shadow(on: (Self) -> Shadow?) -> Self {
        self.shadow = on(self)
        return self
    }
    
}

public extension IViewSupportShadow where Self : CompositorTrait, Body : IViewSupportShadow {
    
    @inlinable
    var shadow: Shadow? {
        set { self.body.shadow = newValue }
        get { self.body.shadow }
    }
    
}
