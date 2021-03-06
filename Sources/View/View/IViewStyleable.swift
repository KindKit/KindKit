//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewStyleable : AnyObject {
    
    func triggeredChangeStyle(_ userInteraction: Bool)
    
    @discardableResult
    func onChangeStyle(_ value: ((_ userInteraction: Bool) -> Void)?) -> Self
    
}

extension IWidgetView where Body : IViewStyleable {
    
    public func triggeredChangeStyle(_ userInteraction: Bool) {
        self.body.triggeredChangeStyle(userInteraction)
    }
    
    @discardableResult
    public func onChangeStyle(_ value: ((_ userInteraction: Bool) -> Void)?) -> Self {
        self.body.onChangeStyle(value)
        return self
    }
    
}
