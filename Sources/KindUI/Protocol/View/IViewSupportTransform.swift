//
//  KindKit
//

import KindGraphics

public protocol IViewSupportTransform : AnyObject {
    
    var transform: Transform { set get }
    
}

public extension IViewSupportTransform where Self : IComposite, BodyType : IViewSupportTransform {
    
    @inlinable
    var transform: Transform {
        set { self.body.transform = newValue }
        get { self.body.transform }
    }
    
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
    func transform(_ value: () -> Transform) -> Self {
        return self.transform(value())
    }

    @inlinable
    @discardableResult
    func transform(_ value: (Self) -> Transform) -> Self {
        return self.transform(value(self))
    }
    
}
