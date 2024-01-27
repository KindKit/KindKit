//
//  KindKit
//

public protocol IViewContainSeparator : AnyObject {
    
    associatedtype Separator : IView
    
    var separator: Separator { set get }
    
}

public extension IViewContainSeparator {
    
    @inlinable
    @discardableResult
    func separator(_ value: Separator) -> Self {
        self.separator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separator(on: () -> Separator) -> Self {
        self.separator = on()
        return self
    }

    @inlinable
    @discardableResult
    func separator(on: (Self) -> Separator) -> Self {
        self.separator = on(self)
        return self
    }
    
}

public extension IViewContainSeparator where Self : CompositorTrait, Body : IViewContainSeparator {
    
    @inlinable
    var separator: Body.Separator {
        set { self.body.separator = newValue }
        get { self.body.separator }
    }
    
}
