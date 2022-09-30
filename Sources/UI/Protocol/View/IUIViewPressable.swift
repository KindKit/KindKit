//
//  KindKit
//

import Foundation

public protocol IUIViewPressable : AnyObject {
    
    var shouldPressed: Bool { set get }
    
    @discardableResult
    func onPressed(_ value: ((Self) -> Void)?) -> Self
    
}

public extension IUIViewPressable {
    
    @inlinable
    @discardableResult
    func shouldPressed(_ value: Bool) -> Self {
        self.shouldPressed = value
        return self
    }
    
}

public extension IUIViewPressable where Self : IUIWidgetView, Body : IUIViewPressable {
    
    @inlinable
    var shouldPressed: Bool {
        set { self.body.shouldPressed = newValue }
        get { return self.body.shouldPressed }
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ value: ((Self) -> Void)?) -> Self {
        if let value = value {
            self.body.onPressed({ [unowned self] _ in value(self) })
        } else {
            self.body.onPressed(nil)
        }
        return self
    }
    
}
