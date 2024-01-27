//
//  KindKit
//

import KindGraphics

public protocol IViewSupportColor : AnyObject {
    
    var color: Color { set get }
    
}

public extension IViewSupportColor where Self : IComposite, BodyType : IViewSupportColor {
    
    @inlinable
    var color: Color {
        set { self.body.color = newValue }
        get { self.body.color }
    }
    
}

public extension IViewSupportColor {
    
    @inlinable
    @discardableResult
    func color(_ value: Color) -> Self {
        self.color = value
        return self
    }
    
    @inlinable
    @discardableResult
    func color(_ value: () -> Color) -> Self {
        return self.color(value())
    }

    @inlinable
    @discardableResult
    func color(_ value: (Self) -> Color) -> Self {
        return self.color(value(self))
    }
    
}
