//
//  KindKit
//

import Foundation

public protocol IUIViewAnimatable : AnyObject {
    
    var isAnimating: Bool { set get }
    
}

public extension IUIViewAnimatable {
    
    @inlinable
    @discardableResult
    func animating(_ value: Bool) -> Self {
        self.isAnimating = value
        return self
    }
    
}

public extension IUIViewAnimatable where Self : IUIWidgetView, Body : IUIViewAnimatable {
    
    @inlinable
    var isAnimating: Bool {
        set(value) { self.body.isAnimating = value }
        get { return self.body.isAnimating }
    }
    
}
