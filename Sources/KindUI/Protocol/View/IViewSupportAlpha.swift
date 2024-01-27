//
//  KindKit
//

public protocol IViewSupportAlpha : AnyObject {
    
    var alpha: Double { set get }
    
}

public extension IViewSupportAlpha where Self : IComposite, BodyType : IViewSupportAlpha {
    
    @inlinable
    var alpha: Double {
        set { self.body.alpha = newValue }
        get { self.body.alpha }
    }
    
}

public extension IViewSupportAlpha {
    
    @inlinable
    @discardableResult
    func alpha(_ value: Double) -> Self {
        self.alpha = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alpha(_ value: () -> Double) -> Self {
        return self.alpha(value())
    }

    @inlinable
    @discardableResult
    func alpha(_ value: (Self) -> Double) -> Self {
        return self.alpha(value(self))
    }
    
}
