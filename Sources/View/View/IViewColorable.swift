//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewColorable : AnyObject {
    
    var color: Color? { set get }
    
    @discardableResult
    func color(_ value: Color?) -> Self
    
}

extension IWidgetView where Body : IViewColorable {
    
    public var color: Color? {
        set(value) { self.body.color = value }
        get { return self.body.color }
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.body.color(value)
        return self
    }
    
}
