//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewDynamicSizeBehavioural : AnyObject {
    
    var width: DynamicSizeBehaviour { set get }
    
    var height: DynamicSizeBehaviour { set get }
    
    @discardableResult
    func width(_ value: DynamicSizeBehaviour) -> Self
    
    @discardableResult
    func height(_ value: DynamicSizeBehaviour) -> Self
    
}

extension IWidgetView where Body : IViewDynamicSizeBehavioural {
    
    public var width: DynamicSizeBehaviour {
        set(value) { self.body.width = value }
        get { return self.body.width }
    }
    
    public var height: DynamicSizeBehaviour {
        set(value) { self.body.height = value }
        get { return self.body.height }
    }
    
    @discardableResult
    public func width(_ value: DynamicSizeBehaviour) -> Self {
        self.body.width(value)
        return self
    }
    
    @discardableResult
    public func height(_ value: DynamicSizeBehaviour) -> Self {
        self.body.height(value)
        return self
    }
    
}
