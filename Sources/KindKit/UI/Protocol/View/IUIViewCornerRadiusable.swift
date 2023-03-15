//
//  KindKit
//

import Foundation

public protocol IUIViewCornerRadiusable : AnyObject {
    
    var cornerRadius: UI.CornerRadius { set get }
    
}

public extension IUIViewCornerRadiusable where Self : IUIWidgetView, Body : IUIViewCornerRadiusable {
    
    @inlinable
    var cornerRadius: UI.CornerRadius {
        set { self.body.cornerRadius = newValue }
        get { self.body.cornerRadius }
    }
    
}

public extension IUIViewCornerRadiusable {
    
    @inlinable
    @discardableResult
    func cornerRadius(_ value: UI.CornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
    @inlinable
    @discardableResult
    func cornerRadius(_ value: () -> UI.CornerRadius) -> Self {
        return self.cornerRadius(value())
    }

    @inlinable
    @discardableResult
    func cornerRadius(_ value: (Self) -> UI.CornerRadius) -> Self {
        return self.cornerRadius(value(self))
    }
    
}
