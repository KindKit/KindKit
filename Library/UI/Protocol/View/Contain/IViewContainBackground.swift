//
//  KindKit
//

public protocol IViewContainBackground : AnyObject {
    
    associatedtype Background : IView
    
    var background: Background { set get }
    
}

public extension IViewContainBackground {
    
    @inlinable
    @discardableResult
    func background(_ value: Background) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(on: () -> Background) -> Self {
        self.background = on()
        return self
    }

    @inlinable
    @discardableResult
    func background(on: (Self) -> Background) -> Self {
        self.background = on(self)
        return self
    }
    
}

public extension IViewContainBackground where Self : CompositorTrait, Body : IViewContainBackground {
    
    @inlinable
    var background: Body.Background {
        set { self.body.background = newValue }
        get { self.body.background }
    }
    
}
