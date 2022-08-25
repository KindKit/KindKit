//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewStaticSizeBehavioural : AnyObject {
    
    var width: StaticSizeBehaviour { set get }
    
    var height: StaticSizeBehaviour { set get }
    
}

public extension IViewStaticSizeBehavioural {
    
    @inlinable
    @discardableResult
    func width(_ value: StaticSizeBehaviour) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: StaticSizeBehaviour) -> Self {
        self.height = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewStaticSizeBehavioural {
    
    @inlinable
    var width: StaticSizeBehaviour {
        set(value) { self.body.width = value }
        get { return self.body.width }
    }
    
    @inlinable
    var height: StaticSizeBehaviour {
        set(value) { self.body.height = value }
        get { return self.body.height }
    }
    
    @inlinable
    @discardableResult
    func width(_ value: StaticSizeBehaviour) -> Self {
        self.body.width(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: StaticSizeBehaviour) -> Self {
        self.body.height(value)
        return self
    }
    
}
