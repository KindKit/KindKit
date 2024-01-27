//
//  KindKit
//

import KindGraphics

public protocol IViewSupportTransform : AnyObject {
    
    var transform: Transform { set get }
    
}

public extension IViewSupportTransform {
    
    @inlinable
    @discardableResult
    func transform(_ value: Transform) -> Self {
        self.transform = value
        return self
    }
    
    @inlinable
    @discardableResult
    func transform(on: () -> Transform) -> Self {
        self.transform = on()
        return self
    }

    @inlinable
    @discardableResult
    func transform(on: (Self) -> Transform) -> Self {
        self.transform = on(self)
        return self
    }
    
}

public extension IViewSupportTransform where Self : CompositorTrait, Body : IViewSupportTransform {
    
    @inlinable
    var transform: Transform {
        set { self.body.transform = newValue }
        get { self.body.transform }
    }
    
}
