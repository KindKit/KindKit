//
//  KindKit
//

import Foundation

public protocol IUIViewAspectSizeable : AnyObject {
    
    var aspectRatio: Float? { set get }
    
}

public extension IUIViewAspectSizeable where Self : IUIWidgetView, Body : IUIViewAspectSizeable {
    
    @inlinable
    var aspectRatio: Float? {
        set { self.body.aspectRatio = newValue }
        get { self.body.aspectRatio }
    }
    
}

public extension IUIViewAspectSizeable {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
}
