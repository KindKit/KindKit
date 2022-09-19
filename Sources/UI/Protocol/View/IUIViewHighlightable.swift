//
//  KindKit
//

import Foundation

public protocol IUIViewHighlightable : IUIViewStyleable {
    
    var isHighlighted: Bool { set get }
    
}

public extension IUIViewHighlightable {
    
    @inlinable
    @discardableResult
    func highlight(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
}

public extension IUIViewHighlightable where Self : IUIWidgetView, Body : IUIViewHighlightable {
    
    @inlinable
    var isHighlighted: Bool {
        set(value) { self.body.isHighlighted = value }
        get { return self.body.isHighlighted }
    }
    
}
