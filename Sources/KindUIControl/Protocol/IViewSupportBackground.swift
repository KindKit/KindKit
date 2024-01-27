//
//  KindKit
//

import KindUI

public protocol IViewSupportBackground : AnyObject {
    
    associatedtype BackgroundType : IView
    
    var background: BackgroundType { set get }
    
}

public extension IViewSupportBackground {
    
    @inlinable
    @discardableResult
    func background(_ value: BackgroundType) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(_ value: () -> BackgroundType) -> Self {
        return self.background(value())
    }

    @inlinable
    @discardableResult
    func background(_ value: (Self) -> BackgroundType) -> Self {
        return self.background(value(self))
    }
    
}

public extension IViewSupportBackground where Self : IComposite, BodyType : IViewSupportBackground {
    
    @inlinable
    var background: BodyType.BackgroundType {
        set { self.body.background = newValue }
        get { self.body.background }
    }
    
}
