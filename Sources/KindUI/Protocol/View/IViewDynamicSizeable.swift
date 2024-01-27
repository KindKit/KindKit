//
//  KindKit
//

import KindLayout

public protocol IViewDynamicSizeable : AnyObject {
    
    var size: DynamicSize { set get }
    
}

public extension IViewDynamicSizeable where Self : IComposite, BodyType : IViewDynamicSizeable {
    
    @inlinable
    var size: DynamicSize {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}

public extension IViewDynamicSizeable {
    
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
    
}

public extension IViewDynamicSizeable {
    
    @inlinable
    var width: DynamicSize.Axis {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    @discardableResult
    func width(_ value: DynamicSize.Axis) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func width(_ value: () -> DynamicSize.Axis) -> Self {
        return self.width(value())
    }

    @inlinable
    @discardableResult
    func width(_ value: (Self) -> DynamicSize.Axis) -> Self {
        return self.width(value(self))
    }
    
}

public extension IViewDynamicSizeable {
    
    @inlinable
    var height: DynamicSize.Axis {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
    @inlinable
    @discardableResult
    func height(_ value: DynamicSize.Axis) -> Self {
        self.height = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(_ value: () -> DynamicSize.Axis) -> Self {
        return self.height(value())
    }

    @inlinable
    @discardableResult
    func height(_ value: (Self) -> DynamicSize.Axis) -> Self {
        return self.height(value(self))
    }
    
}
