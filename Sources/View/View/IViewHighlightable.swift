//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IViewHighlightable : IViewStyleable {
    
    var isHighlighted: Bool { set get }
    
}

public extension IViewHighlightable {
    
    @inlinable
    @discardableResult
    func highlight(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewHighlightable {
    
    @inlinable
    var isHighlighted: Bool {
        set(value) { self.body.isHighlighted = value }
        get { return self.body.isHighlighted }
    }
    
    @inlinable
    @discardableResult
    func highlight(_ value: Bool) -> Self {
        self.body.highlight(value)
        return self
    }
    
}
