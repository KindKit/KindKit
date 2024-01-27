//
//  KindKit
//

import KindGraphics

public protocol IViewSupportContent : AnyObject {
    
    associatedtype Content
    
    var content: Content { set get }
    
}

public extension IViewSupportContent {
    
    @inlinable
    @discardableResult
    func content(_ value: Content) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(on: () -> Content) -> Self {
        self.content = on()
        return self
    }

    @inlinable
    @discardableResult
    func content(on: (Self) -> Content) -> Self {
        self.content = on(self)
        return self
    }
    
}

public extension IViewSupportContent where Self : CompositorTrait, Body : IViewSupportContent {
    
    @inlinable
    var content: Body.Content {
        set { self.body.content = newValue }
        get { self.body.content }
    }
    
}
