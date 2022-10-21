//
//  KindKit
//

import Foundation

public protocol IUIViewStaticSizeable : AnyObject {
    
    var size: UI.Size.Static { set get }
    
}

public extension IUIViewStaticSizeable where Self : IUIWidgetView, Body : IUIViewStaticSizeable {
    
    @inlinable
    var size: UI.Size.Static {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}

public extension IUIViewStaticSizeable {
    
    @inlinable
    var width: UI.Size.Static.Dimension? {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    var height: UI.Size.Static.Dimension? {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
    @inlinable
    @discardableResult
    func size(_ width: UI.Size.Static.Dimension, _ height: UI.Size.Static.Dimension) -> Self {
        self.size = .init(width: width, height: height)
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: UI.Size.Static) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func width(_ value: UI.Size.Static.Dimension) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: UI.Size.Static.Dimension) -> Self {
        self.height = value
        return self
    }
    
}
