//
//  KindKit
//

import KindGraphics

public protocol IViewSupportContentInset : AnyObject {
    
    var contentInset: Inset { set get }
    
}

public extension IViewSupportContentInset {
    
    @inlinable 
    @discardableResult
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }

    @inlinable 
    @discardableResult
    func contentInset(on: () -> Inset) -> Self {
        self.contentInset = on()
        return self
    }

    @inlinable 
    @discardableResult
    func contentInset(on: (Self) -> Inset) -> Self {
        self.contentInset = on(self)
        return self
    }
    
}

public extension IViewSupportContentInset where Self : CompositorTrait, Body : IViewSupportContentInset {
    
    @inlinable
    var contentInset: Inset {
        set { self.body.contentInset = newValue }
        get { self.body.contentInset }
    }
    
}
