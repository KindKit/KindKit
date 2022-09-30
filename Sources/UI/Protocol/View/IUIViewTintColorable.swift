//
//  KindKit
//

import Foundation

public protocol IUIViewTintColorable : AnyObject {
    
    var tintColor: UI.Color? { set get }
    
}

public extension IUIViewTintColorable {
    
    @inlinable
    @discardableResult
    func tintColor(_ value: UI.Color?) -> Self {
        self.tintColor = value
        return self
    }
    
}

public extension IUIViewTintColorable where Self : IUIWidgetView, Body : IUIViewTintColorable {
    
    @inlinable
    var tintColor: UI.Color? {
        set { self.body.tintColor = newValue }
        get { return self.body.tintColor }
    }
    
}
