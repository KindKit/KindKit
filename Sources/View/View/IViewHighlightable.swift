//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewHighlightable : IViewStyleable {
    
    var isHighlighted: Bool { set get }
    
    @discardableResult
    func highlight(_ value: Bool) -> Self
    
}

extension IWidgetView where Body : IViewHighlightable {
    
    public var isHighlighted: Bool {
        set(value) { self.body.isHighlighted = value }
        get { return self.body.isHighlighted }
    }
    
    @discardableResult
    public func highlight(_ value: Bool) -> Self {
        self.body.highlight(value)
        return self
    }
    
}
