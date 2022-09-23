//
//  KindKit
//

import Foundation

public protocol IUIViewColorable : AnyObject {
    
    var color: UI.Color? { set get }
    
    
}

public extension IUIViewColorable {
    
    @inlinable
    @discardableResult
    func color(_ value: UI.Color?) -> Self {
        self.color = value
        return self
    }
    
}

public extension IUIViewColorable where Self : IUIWidgetView, Body : IUIViewColorable {
    
    @inlinable
    var color: UI.Color? {
        set(value) { self.body.color = value }
        get { return self.body.color }
    }
    
}
