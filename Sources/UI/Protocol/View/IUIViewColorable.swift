//
//  KindKit
//

import Foundation

public protocol IUIViewColorable : AnyObject {
    
    var color: UI.Color? { set get }
    
    
}

public extension IUIViewColorable where Self : IUIWidgetView, Body : IUIViewColorable {
    
    @inlinable
    var color: UI.Color? {
        set { self.body.color = newValue }
        get { self.body.color }
    }
    
}

public extension IUIViewColorable {
    
    @inlinable
    @discardableResult
    func color(_ value: UI.Color?) -> Self {
        self.color = value
        return self
    }
    
}
