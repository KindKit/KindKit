//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewAlphable : AnyObject {
    
    var alpha: Float { set get }
    
    @discardableResult
    func alpha(_ value: Float) -> Self
    
}

extension IWidgetView where Body : IViewAlphable {
    
    public var alpha: Float {
        set(value) { self.body.alpha = value }
        get { return self.body.alpha }
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self.body.alpha(value)
        return self
    }
    
}
