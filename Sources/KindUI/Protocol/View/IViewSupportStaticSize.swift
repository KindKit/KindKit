//
//  KindKit
//

import KindLayout

public protocol IViewSupportStaticSize : AnyObject {
    
    var size: StaticSize { set get }
    
}

public extension IViewSupportStaticSize where Self : IComposite, BodyType : IViewSupportStaticSize {
    
    @inlinable
    var size: StaticSize {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
}

public extension IViewSupportStaticSize where Self : IView {
    
    func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(by: request)
    }
    
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
    func size(_ value: () -> StaticSize) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> StaticSize) -> Self {
        return self.size(value(self))
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
    func width(_ value: () -> StaticSize.Axis) -> Self {
        return self.width(value())
    }

    @inlinable
    @discardableResult
    func width(_ value: (Self) -> StaticSize.Axis) -> Self {
        return self.width(value(self))
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
    func height(_ value: () -> StaticSize.Axis) -> Self {
        return self.height(value())
    }

    @inlinable
    @discardableResult
    func height(_ value: (Self) -> StaticSize.Axis) -> Self {
        return self.height(value(self))
    }
    
}
