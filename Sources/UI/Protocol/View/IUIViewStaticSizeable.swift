//
//  KindKit
//

import Foundation

public protocol IUIViewStaticSizeable : AnyObject {
    
    var width: UI.Size.Static { set get }
    
    var height: UI.Size.Static { set get }
    
}

public extension IUIViewStaticSizeable {
    
    @inlinable
    @discardableResult
    func width(_ value: UI.Size.Static) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: UI.Size.Static) -> Self {
        self.height = value
        return self
    }
    
}

public extension IUIViewStaticSizeable where Self : IUIWidgetView, Body : IUIViewStaticSizeable {
    
    @inlinable
    var width: UI.Size.Static {
        set(value) { self.body.width = value }
        get { return self.body.width }
    }
    
    @inlinable
    var height: UI.Size.Static {
        set(value) { self.body.height = value }
        get { return self.body.height }
    }
    
}
