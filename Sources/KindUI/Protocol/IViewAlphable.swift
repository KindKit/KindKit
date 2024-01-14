//
//  KindKit
//

public protocol IViewAlphable : AnyObject {
    
    var alpha: Double { set get }
    
}

public extension IViewAlphable where Self : IWidgetView, Body : IViewAlphable {
    
    @inlinable
    var alpha: Double {
        set { self.body.alpha = newValue }
        get { self.body.alpha }
    }
    
}

public extension IViewAlphable {
    
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
