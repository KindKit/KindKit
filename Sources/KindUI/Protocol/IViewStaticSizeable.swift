//
//  KindKit
//

public protocol IViewStaticSizeable : AnyObject {
    
    var size: StaticSize { set get }
    
}

public extension IViewStaticSizeable where Self : IWidgetView, Body : IViewStaticSizeable {
    
    @inlinable
    var size: StaticSize {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}

public extension IViewStaticSizeable {
    
    @inlinable
    var width: StaticSize.Dimension {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    var height: StaticSize.Dimension {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
    @inlinable
    @discardableResult
    func size(_ width: StaticSize.Dimension, _ height: StaticSize.Dimension) -> Self {
        self.size = .init(width, height)
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: StaticSize) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> StaticSize) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> StaticSize) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func width(_ value: StaticSize.Dimension) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func width(_ value: () -> StaticSize.Dimension) -> Self {
        return self.width(value())
    }

    @inlinable
    @discardableResult
    func width(_ value: (Self) -> StaticSize.Dimension) -> Self {
        return self.width(value(self))
    }
    
    @inlinable
    @discardableResult
    func height(_ value: StaticSize.Dimension) -> Self {
        self.height = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: () -> StaticSize.Dimension) -> Self {
        return self.height(value())
    }

    @inlinable
    @discardableResult
    func height(_ value: (Self) -> StaticSize.Dimension) -> Self {
        return self.height(value(self))
    }
    
}
