//
//  KindKit
//

import Foundation

public protocol IUIViewTintColorable : AnyObject {
    
    var tintColor: Color? { set get }
    
}

public extension IUIViewTintColorable {
    
    @inlinable
    @discardableResult
    func tintColor(_ value: Color?) -> Self {
        self.tintColor = value
        return self
    }
    
}

public extension IUIViewTintColorable where Self : IUIWidgetView, Body : IUIViewTintColorable {
    
    @inlinable
    var tintColor: Color? {
        set(value) { self.body.tintColor = value }
        get { return self.body.tintColor }
    }
    
}
