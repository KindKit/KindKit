//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewColorable : AnyObject {
    
    var color: Color? { set get }
    
    
}

public extension IViewColorable {
    
    @inlinable
    @discardableResult
    func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
}


public extension IWidgetView where Body : IViewColorable {
    
    @inlinable
    var color: Color? {
        set(value) { self.body.color = value }
        get { return self.body.color }
    }
    
    @inlinable
    @discardableResult
    func color(_ value: Color?) -> Self {
        self.body.color(value)
        return self
    }
    
}
