//
//  KindKit
//

import Foundation

public protocol IUIViewStaticSizeable : AnyObject {
    
    var width: UI.Size.Static { set get }
    
    var height: UI.Size.Static { set get }
    
}

public extension IUIViewStaticSizeable where Self : IUIWidgetView, Body : IUIViewStaticSizeable {
    
    @inlinable
    var width: UI.Size.Static {
        set { self.body.width = newValue }
        get { self.body.width }
    }
    
    @inlinable
    var height: UI.Size.Static {
        set { self.body.height = newValue }
        get { self.body.height }
    }
    
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
