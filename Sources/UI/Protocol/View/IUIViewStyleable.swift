//
//  KindKit
//

import Foundation

public protocol IUIViewStyleable : AnyObject {
    
    func triggeredChangeStyle(_ userInteraction: Bool)
    
    @discardableResult
    func onChangeStyle(_ value: ((Self, Bool) -> Void)?) -> Self
    
}

public extension IUIViewStyleable where Self : IUIWidgetView, Body : IUIViewStyleable {
    
    @inlinable
    func triggeredChangeStyle(_ userInteraction: Bool) {
        self.body.triggeredChangeStyle(userInteraction)
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((Self, Bool) -> Void)?) -> Self {
        if let value = value {
            self.body.onChangeStyle({ [unowned self] in value(self, $1) })
        } else {
            self.body.onChangeStyle(nil)
        }
        return self
    }
    
}
