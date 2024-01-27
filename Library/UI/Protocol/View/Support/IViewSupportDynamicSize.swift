//
//  KindKit
//

import KindLayout

public protocol IViewSupportDynamicSize : AnyObject {
    
    var size: DynamicSize { set get }
    
}

public extension IViewSupportDynamicSize {
    
    @inlinable
    @discardableResult
    func size(_ value: DynamicSize) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(on: () -> DynamicSize) -> Self {
        self.size = on()
        return self
    }

    @inlinable
    @discardableResult
    func size(on: (Self) -> DynamicSize) -> Self {
        self.size = on(self)
        return self
    }
    
}

public extension IViewSupportDynamicSize {
    
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
    func width(on: () -> DynamicSize.Axis) -> Self {
        self.width = on()
        return self
    }

    @inlinable
    @discardableResult
    func width(on: (Self) -> DynamicSize.Axis) -> Self {
        self.width = on(self)
        return self
    }
    
}

public extension IViewSupportDynamicSize {
    
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
    func height(on: () -> DynamicSize.Axis) -> Self {
        self.height = on()
        return self
    }

    @inlinable
    @discardableResult
    func height(on: (Self) -> DynamicSize.Axis) -> Self {
        self.height = on(self)
        return self
    }
    
}

public extension IViewSupportDynamicSize where Self : CompositorTrait, Body : IViewSupportDynamicSize {
    
    @inlinable
    var size: DynamicSize {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}
