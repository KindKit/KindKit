//
//  KindKit
//

import KindUI

public protocol IViewSupportInset : AnyObject {
    
    var inset: Inset { set get }
    
}

public extension IViewSupportInset {
    
    @inlinable 
    @discardableResult
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }

    @inlinable 
    @discardableResult
    func inset(_ value: () -> Inset) -> Self {
        self.inset = value()
        return self
    }

    @inlinable 
    @discardableResult
    func inset(_ value: (Self) -> Inset) -> Self {
        self.inset = value(self)
        return self
    }
    
}

public extension IViewSupportInset where Self : IComposite, BodyType : IViewSupportInset {
    
    @inlinable
    var inset: Inset {
        set { self.body.inset = newValue }
        get { self.body.inset }
    }
    
}
