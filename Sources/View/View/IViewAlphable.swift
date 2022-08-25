//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewAlphable : AnyObject {
    
    var alpha: Float { set get }
    
}

public extension IViewAlphable {
    
    @inlinable
    @discardableResult
    func alpha(_ value: Float) -> Self {
        self.alpha = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewAlphable {
    
    @inlinable
    var alpha: Float {
        set(value) { self.body.alpha = value }
        get { return self.body.alpha }
    }
    
    @inlinable
    @discardableResult
    func alpha(_ value: Float) -> Self {
        self.body.alpha(value)
        return self
    }
    
}
