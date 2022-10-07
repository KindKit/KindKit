//
//  KindKit
//

import Foundation

public protocol IUIViewAnimatable : AnyObject {
    
    var isAnimating: Bool { set get }
    
}

public extension IUIViewAnimatable where Self : IUIWidgetView, Body : IUIViewAnimatable {
    
    @inlinable
    var isAnimating: Bool {
        set { self.body.isAnimating = newValue }
        get { self.body.isAnimating }
    }
    
}

public extension IUIViewAnimatable {
    
    @inlinable
    @discardableResult
    func isAnimating(_ value: Bool) -> Self {
        self.isAnimating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animate(_ value: Bool) -> Self {
        self.isAnimating = value
        return self
    }
    
}
