//
//  KindKit
//

import Foundation

public protocol IUIViewAlphable : AnyObject {
    
    var alpha: Float { set get }
    
}

public extension IUIViewAlphable {
    
    @inlinable
    @discardableResult
    func alpha(_ value: Float) -> Self {
        self.alpha = value
        return self
    }
    
}

public extension IUIViewAlphable where Self : IUIWidgetView, Body : IUIViewAlphable {
    
    @inlinable
    var alpha: Float {
        set { self.body.alpha = newValue }
        get { return self.body.alpha }
    }
    
}
