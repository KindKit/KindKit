//
//  KindKit
//

import Foundation

public protocol IUIViewShadowable : AnyObject {
    
    var shadow: UI.Shadow? { set get }
    
}

public extension IUIViewShadowable {
    
    @inlinable
    @discardableResult
    func shadow(_ value: UI.Shadow?) -> Self {
        self.shadow = value
        return self
    }
    
}

public extension IUIViewShadowable where Self : IUIWidgetView, Body : IUIViewShadowable {
    
    @inlinable
    var shadow: UI.Shadow? {
        set { self.body.shadow = newValue }
        get { return self.body.shadow }
    }
    
}
