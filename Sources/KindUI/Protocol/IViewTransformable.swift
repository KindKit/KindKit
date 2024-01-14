//
//  KindKit
//

import KindGraphics

public protocol IViewTransformable : AnyObject {
    
    var transform: Transform { set get }
    
}

public extension IViewTransformable where Self : IWidgetView, Body : IViewTransformable {
    
    @inlinable
    var transform: Transform {
        set { self.body.transform = newValue }
        get { self.body.transform }
    }
    
}

public extension IViewTransformable {
    
    @inlinable
    @discardableResult
    func transform(_ value: Transform) -> Self {
        self.transform = value
        return self
    }
    
    @inlinable
    @discardableResult
    func transform(_ value: () -> Transform) -> Self {
        return self.transform(value())
    }

    @inlinable
    @discardableResult
    func transform(_ value: (Self) -> Transform) -> Self {
        return self.transform(value(self))
    }
    
}
