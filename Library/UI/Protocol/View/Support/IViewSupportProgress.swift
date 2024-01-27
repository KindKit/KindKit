//
//  KindKit
//

public protocol IViewSupportProgress : AnyObject {
    
    var progress: Double { set get }
    
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
    func progress(on: () -> Double) -> Self {
        self.progress = on()
        return self
    }

    @inlinable
    @discardableResult
    func progress(on: (Self) -> Double) -> Self {
        self.progress = on(self)
        return self
    }
    
}

public extension IViewSupportProgress where Self : CompositorTrait, Body : IViewSupportProgress {
    
    @inlinable
    var progress: Double {
        set { self.body.progress = newValue }
        get { self.body.progress }
    }
    
}
