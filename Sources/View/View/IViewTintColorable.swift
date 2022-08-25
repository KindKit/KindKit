//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewTintColorable : AnyObject {
    
    var tintColor: Color? { set get }
    
}

public extension IViewTintColorable {
    
    @inlinable
    @discardableResult
    func tintColor(_ value: Color?) -> Self {
        self.tintColor = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewTintColorable {
    
    @inlinable
    var tintColor: Color? {
        set(value) { self.body.tintColor = value }
        get { return self.body.tintColor }
    }
    
    @inlinable
    @discardableResult
    func tintColor(_ value: Color?) -> Self {
        self.body.tintColor(value)
        return self
    }
    
}
