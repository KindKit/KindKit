//
//  KindKit
//

import Foundation

public protocol IUIViewDynamicSizeable : AnyObject {
    
    var size: UI.Size.Dynamic { set get }
    
}

public extension IUIViewDynamicSizeable where Self : IUIWidgetView, Body : IUIViewDynamicSizeable {
    
    @inlinable
    var size: UI.Size.Dynamic {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}

public extension IUIViewDynamicSizeable {
    
    @inlinable
    var width: UI.Size.Dynamic.Dimension {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    var height: UI.Size.Dynamic.Dimension {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
    @inlinable
    @discardableResult
    func size(_ width: UI.Size.Dynamic.Dimension, _ height: UI.Size.Dynamic.Dimension) -> Self {
        self.size = .init(width, height)
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: UI.Size.Dynamic) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func width(_ value: UI.Size.Dynamic.Dimension) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: UI.Size.Dynamic.Dimension) -> Self {
        self.height = value
        return self
    }
    
}
