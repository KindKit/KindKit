//
//  KindKit
//

import Foundation

public protocol IUIViewAlphable : AnyObject {
    
    var alpha: Double { set get }
    
}

public extension IUIViewAlphable where Self : IUIWidgetView, Body : IUIViewAlphable {
    
    @inlinable
    var alpha: Double {
        set { self.body.alpha = newValue }
        get { self.body.alpha }
    }
    
}

public extension IUIViewAlphable {
    
    @inlinable
    @discardableResult
    func alpha(_ value: Double) -> Self {
        self.alpha = value
        return self
    }
    
}
