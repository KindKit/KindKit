//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewStaticSizeBehavioural : AnyObject {
    
    var width: StaticSizeBehaviour { set get }
    
    var height: StaticSizeBehaviour { set get }
    
    @discardableResult
    func width(_ value: StaticSizeBehaviour) -> Self
    
    @discardableResult
    func height(_ value: StaticSizeBehaviour) -> Self
    
}

extension IWidgetView where Body : IViewStaticSizeBehavioural {
    
    public var width: StaticSizeBehaviour {
        set(value) { self.body.width = value }
        get { return self.body.width }
    }
    
    public var height: StaticSizeBehaviour {
        set(value) { self.body.height = value }
        get { return self.body.height }
    }
    
    @discardableResult
    public func width(_ value: StaticSizeBehaviour) -> Self {
        self.body.width(value)
        return self
    }
    
    @discardableResult
    public func height(_ value: StaticSizeBehaviour) -> Self {
        self.body.height(value)
        return self
    }
    
}
