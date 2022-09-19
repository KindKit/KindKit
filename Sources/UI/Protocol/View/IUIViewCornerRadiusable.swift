//
//  KindKit
//

import Foundation

public protocol IUIViewCornerRadiusable : AnyObject {
    
    var cornerRadius: UI.CornerRadius { set get }
    
}

public extension IUIViewCornerRadiusable {
    
    @inlinable
    @discardableResult
    func cornerRadius(_ value: UI.CornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
}

public extension IUIViewCornerRadiusable where Self : IUIWidgetView, Body : IUIViewCornerRadiusable {
    
    @inlinable
    var cornerRadius: UI.CornerRadius {
        set(value) { self.body.cornerRadius = value }
        get { return self.body.cornerRadius }
    }
    
}
