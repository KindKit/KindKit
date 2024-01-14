//
//  KindKit
//

public protocol IViewProgressable : AnyObject {
    
    var progress: Double { set get }
    
}

public extension IViewProgressable where Self : IWidgetView, Body : IViewProgressable {
    
    @inlinable
    var progress: Double {
        set { self.body.progress = newValue }
        get { self.body.progress }
    }
    
}

public extension IViewProgressable {
    
    @inlinable
    @discardableResult
    func progress(_ value: Double) -> Self {
        self.progress = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progress(_ value: () -> Double) -> Self {
        return self.progress(value())
    }

    @inlinable
    @discardableResult
    func progress(_ value: (Self) -> Double) -> Self {
        return self.progress(value(self))
    }
    
}
