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
    
    @inlinable
    @discardableResult
    func alpha(_ value: () -> Double) -> Self {
        return self.alpha(value())
    }

    @inlinable
    @discardableResult
    func alpha(_ value: (Self) -> Double) -> Self {
        return self.alpha(value(self))
    }
    
}
