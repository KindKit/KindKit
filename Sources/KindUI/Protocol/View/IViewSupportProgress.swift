//
//  KindKit
//

public protocol IViewSupportProgress : AnyObject {
    
    var progress: Double { set get }
    
}

public extension IViewSupportProgress where Self : IComposite, BodyType : IViewSupportProgress {
    
    @inlinable
    var progress: Double {
        set { self.body.progress = newValue }
        get { self.body.progress }
    }
    
}

public extension IViewSupportProgress {
    
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
