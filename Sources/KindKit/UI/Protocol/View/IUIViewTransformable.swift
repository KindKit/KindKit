//
//  KindKit
//

import Foundation

public protocol IUIViewTransformable : AnyObject {
    
    var transform: UI.Transform { set get }
    
}

public extension IUIViewTransformable where Self : IUIWidgetView, Body : IUIViewTransformable {
    
    @inlinable
    var transform: UI.Transform {
        set { self.body.transform = newValue }
        get { self.body.transform }
    }
    
}

public extension IUIViewTransformable {
    
    @inlinable
    @discardableResult
    func transform(_ value: UI.Transform) -> Self {
        self.transform = value
        return self
    }
    
    @inlinable
    @discardableResult
    func transform(_ value: () -> UI.Transform) -> Self {
        return self.transform(value())
    }

    @inlinable
    @discardableResult
    func transform(_ value: (Self) -> UI.Transform) -> Self {
        return self.transform(value(self))
    }
    
}
