//
//  KindKit
//

import KindLayout

public protocol IViewSupportStaticSize : AnyObject {
    
    var size: StaticSize { set get }
    
}

public extension IViewSupportStaticSize {
    
    @inlinable
    @discardableResult
    func size(_ value: StaticSize) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(on: () -> StaticSize) -> Self {
        self.size = on()
        return self
    }

    @inlinable
    @discardableResult
    func size(on: (Self) -> StaticSize) -> Self {
        self.size = on(self)
        return self
    }
    
}

public extension IViewSupportStaticSize {
    
    @inlinable
    var width: StaticSize.Axis {
        set { self.size.width = newValue }
        get { self.size.width }
    }
    
    @inlinable
    @discardableResult
    func width(_ value: StaticSize.Axis) -> Self {
        self.width = value
        return self
    }
    
    @inlinable
    @discardableResult
    func width(on: () -> StaticSize.Axis) -> Self {
        self.width = on()
        return self
    }

    @inlinable
    @discardableResult
    func width(on: (Self) -> StaticSize.Axis) -> Self {
        self.width = on(self)
        return self
    }
    
}

public extension IViewSupportStaticSize {
    
    @inlinable
    var height: StaticSize.Axis {
        set { self.size.height = newValue }
        get { self.size.height }
    }
    
    @inlinable
    @discardableResult
    func height(_ value: StaticSize.Axis) -> Self {
        self.height = value
        return self
    }
    
    @inlinable
    @discardableResult
    func height(on: () -> StaticSize.Axis) -> Self {
        self.height = on()
        return self
    }

    @inlinable
    @discardableResult
    func height(on: (Self) -> StaticSize.Axis) -> Self {
        self.height = on(self)
        return self
    }
    
}

public extension IViewSupportStaticSize where Self : IView {
    
    func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(by: request)
    }
    
}

public extension IViewSupportStaticSize where Self : CompositorTrait, Body : IViewSupportStaticSize {
    
    @inlinable
    var size: StaticSize {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}
