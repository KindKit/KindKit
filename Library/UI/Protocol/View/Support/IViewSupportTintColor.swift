//
//  KindKit
//

import KindGraphics

public protocol IViewSupportTintColor : AnyObject {
    
    var tintColor: Color? { set get }
    
}

public extension IViewSupportTintColor {
    
    @inlinable
    @discardableResult
    func tintColor(_ value: Color?) -> Self {
        self.tintColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func tintColor(on: () -> Color?) -> Self {
        self.tintColor = on()
        return self
    }

    @inlinable
    @discardableResult
    func tintColor(on: (Self) -> Color?) -> Self {
        self.tintColor = on(self)
        return self
    }
    
}

public extension IViewSupportTintColor where Self : CompositorTrait, Body : IViewSupportTintColor {
    
    @inlinable
    var tintColor: Color? {
        set { self.body.tintColor = newValue }
        get { self.body.tintColor }
    }
    
}
