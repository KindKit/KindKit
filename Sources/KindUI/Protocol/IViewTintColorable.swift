//
//  KindKit
//

import KindGraphics

public protocol IViewTintColorable : AnyObject {
    
    var tintColor: Color? { set get }
    
}

public extension IViewTintColorable where Self : IWidgetView, Body : IViewTintColorable {
    
    @inlinable
    var tintColor: Color? {
        set { self.body.tintColor = newValue }
        get { self.body.tintColor }
    }
    
}

public extension IViewTintColorable {
    
    @inlinable
    @discardableResult
    func tintColor(_ value: Color?) -> Self {
        self.tintColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func tintColor(_ value: () -> Color?) -> Self {
        return self.tintColor(value())
    }

    @inlinable
    @discardableResult
    func tintColor(_ value: (Self) -> Color?) -> Self {
        return self.tintColor(value(self))
    }
    
}
