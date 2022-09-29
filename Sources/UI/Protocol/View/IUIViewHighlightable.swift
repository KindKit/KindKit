//
//  KindKit
//

import Foundation

public protocol IUIViewHighlightable : IUIViewStyleable {
    
    var shouldHighlighting: Bool { set get }
    
    var isHighlighted: Bool { set get }
    
}

public extension IUIViewHighlightable {
    
    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self {
        self.shouldHighlighting = value
        return self
    }
    
    @inlinable
    @discardableResult
    func highlight(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
}

public extension IUIViewHighlightable where Self : IUIWidgetView, Body : IUIViewHighlightable {
    
    @inlinable
    var shouldHighlighting: Bool {
        set(value) { self.body.shouldHighlighting = value }
        get { return self.body.shouldHighlighting }
    }
    
    @inlinable
    var isHighlighted: Bool {
        set(value) { self.body.isHighlighted = value }
        get { return self.body.isHighlighted }
    }
    
}
