//
//  KindKit
//

import KindGraphics

public protocol IViewSupportColor : AnyObject {
    
    var color: Color { set get }
    
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
    func color(on: () -> Color) -> Self {
        self.color = on()
        return self
    }

    @inlinable
    @discardableResult
    func color(on: (Self) -> Color) -> Self {
        self.color = on(self)
        return self
    }
    
}

public extension IViewSupportColor where Self : CompositorTrait, Body : IViewSupportColor {
    
    @inlinable
    var color: Color {
        set { self.body.color = newValue }
        get { self.body.color }
    }
    
}
