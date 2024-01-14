//
//  KindKit
//

public protocol IViewDynamicSizeable : AnyObject {
    
    var size: DynamicSize { set get }
    
}

public extension IViewDynamicSizeable where Self : IWidgetView, Body : IViewDynamicSizeable {
    
    @inlinable
    var size: DynamicSize {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}

public extension IViewDynamicSizeable {
    
    @inlinable
    var width: DynamicSize.Dimension {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    var height: DynamicSize.Dimension {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
    @inlinable
    @discardableResult
    func size(_ width: DynamicSize.Dimension, _ height: DynamicSize.Dimension) -> Self {
        self.size = .init(width, height)
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: DynamicSize) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> DynamicSize) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> DynamicSize) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func width(_ value: DynamicSize.Dimension) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func width(_ value: () -> DynamicSize.Dimension) -> Self {
        return self.width(value())
    }

    @inlinable
    @discardableResult
    func width(_ value: (Self) -> DynamicSize.Dimension) -> Self {
        return self.width(value(self))
    }
    
    @inlinable
    @discardableResult
    func height(_ value: DynamicSize.Dimension) -> Self {
        self.height = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: () -> DynamicSize.Dimension) -> Self {
        return self.height(value())
    }

    @inlinable
    @discardableResult
    func height(_ value: (Self) -> DynamicSize.Dimension) -> Self {
        return self.height(value(self))
    }
    
}
