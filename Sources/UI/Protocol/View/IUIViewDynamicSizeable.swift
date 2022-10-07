//
//  KindKit
//

import Foundation

public protocol IUIViewDynamicSizeable : AnyObject {
    
    var width: UI.Size.Dynamic { set get }
    
    var height: UI.Size.Dynamic { set get }
    
}

public extension IUIViewDynamicSizeable where Self : IUIWidgetView, Body : IUIViewDynamicSizeable {
    
    @inlinable
    var width: UI.Size.Dynamic {
        set { self.body.width = newValue }
        get { self.body.width }
    }
    
    @inlinable
    var height: UI.Size.Dynamic {
        set { self.body.height = newValue }
        get { self.body.height }
    }
    
}

public extension IUIViewDynamicSizeable {
    
    @inlinable
    @discardableResult
    func width(_ value: UI.Size.Dynamic) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: UI.Size.Dynamic) -> Self {
        self.height = value
        return self
    }
    
}
