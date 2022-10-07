//
//  KindKit
//

import Foundation

public protocol IUIViewHighlightable : IUIViewStyleable {
    
    var shouldHighlighting: Bool { set get }
    
    var isHighlighted: Bool { set get }
    
}

public extension IUIViewHighlightable where Self : IUIWidgetView, Body : IUIViewHighlightable {
    
    @inlinable
    var shouldHighlighting: Bool {
        set { self.body.shouldHighlighting = newValue }
        get { self.body.shouldHighlighting }
    }
    
    @inlinable
    var isHighlighted: Bool {
        set { self.body.isHighlighted = newValue }
        get { self.body.isHighlighted }
    }
    
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
    func isHighlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @inlinable
    @discardableResult
    func highlight(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
}
