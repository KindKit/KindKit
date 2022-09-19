//
//  KindKit
//

import Foundation

public protocol IUIViewPressable : AnyObject {
    
    @discardableResult
    func onPressed(_ value: ((Self) -> Void)?) -> Self
    
}

public extension IUIViewPressable where Self : IUIWidgetView, Body : IUIViewPressable {
    
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
