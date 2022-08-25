//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewDynamicSizeBehavioural : AnyObject {
    
    var width: DynamicSizeBehaviour { set get }
    
    var height: DynamicSizeBehaviour { set get }
    
}

public extension IViewDynamicSizeBehavioural {
    
    @inlinable
    @discardableResult
    func width(_ value: DynamicSizeBehaviour) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: DynamicSizeBehaviour) -> Self {
        self.height = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewDynamicSizeBehavioural {
    
    @inlinable
    var width: DynamicSizeBehaviour {
        set(value) { self.body.width = value }
        get { return self.body.width }
    }
    
    @inlinable
    var height: DynamicSizeBehaviour {
        set(value) { self.body.height = value }
        get { return self.body.height }
    }
    
    @inlinable
    @discardableResult
    func width(_ value: DynamicSizeBehaviour) -> Self {
        self.body.width(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: DynamicSizeBehaviour) -> Self {
        self.body.height(value)
        return self
    }
    
}
