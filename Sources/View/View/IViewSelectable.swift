//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewSelectable : IViewStyleable {
    
    var isSelected: Bool { set get }
    
    @discardableResult
    func select(_ value: Bool) -> Self
    
}

extension IWidgetView where Body : IViewSelectable {
    
    public var isSelected: Bool {
        set(value) { self.body.isSelected = value }
        get { return self.body.isSelected }
    }
    
    @discardableResult
    public func select(_ value: Bool) -> Self {
        self.body.select(value)
        return self
    }
    
}
