//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewTintColorable : AnyObject {
    
    var tintColor: Color? { set get }
    
    @discardableResult
    func tintColor(_ value: Color?) -> Self
    
}

extension IWidgetView where Body : IViewTintColorable {
    
    public var tintColor: Color? {
        set(value) { self.body.tintColor = value }
        get { return self.body.tintColor }
    }
    
    @discardableResult
    public func tintColor(_ value: Color?) -> Self {
        self.body.tintColor(value)
        return self
    }
    
}
