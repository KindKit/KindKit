//
//  KindKit
//

import KindGraphics

public protocol IViewColorable : AnyObject {
    
    var color: Color? { set get }
    
}

public extension IViewColorable where Self : IWidgetView, Body : IViewColorable {
    
    @inlinable
    var color: Color? {
        set { self.body.color = newValue }
        get { self.body.color }
    }
    
}

public extension IViewColorable {
    
    @inlinable
    @discardableResult
    func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @inlinable
    @discardableResult
    func color(_ value: () -> Color?) -> Self {
        return self.color(value())
    }

    @inlinable
    @discardableResult
    func color(_ value: (Self) -> Color?) -> Self {
        return self.color(value(self))
    }
    
}
