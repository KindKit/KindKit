//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewStyleable : AnyObject {
    
    func triggeredChangeStyle(_ userIteraction: Bool)
    
    @discardableResult
    func onChangeStyle(_ value: ((_ userIteraction: Bool) -> Void)?) -> Self
    
}

extension IWidgetView where Body : IViewStyleable {
    
    public func triggeredChangeStyle(_ userIteraction: Bool) {
        self.body.triggeredChangeStyle(userIteraction)
    }
    
    @discardableResult
    public func onChangeStyle(_ value: ((_ userIteraction: Bool) -> Void)?) -> Self {
        self.body.onChangeStyle(value)
        return self
    }
    
}
