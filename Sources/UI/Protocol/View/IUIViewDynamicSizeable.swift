//
//  KindKit
//

import Foundation

public protocol IUIViewDynamicSizeable : AnyObject {
    
    var width: UI.Size.Dynamic { set get }
    
    var height: UI.Size.Dynamic { set get }
    
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

public extension IUIViewDynamicSizeable where Self : IUIWidgetView, Body : IUIViewDynamicSizeable {
    
    @inlinable
    var width: UI.Size.Dynamic {
        set(value) { self.body.width = value }
        get { return self.body.width }
    }
    
    @inlinable
    var height: UI.Size.Dynamic {
        set(value) { self.body.height = value }
        get { return self.body.height }
    }
    
}
