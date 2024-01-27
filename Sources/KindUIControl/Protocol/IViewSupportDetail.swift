//
//  KindKit
//

import KindUI

public protocol IViewSupportDetail : AnyObject {
    
    associatedtype DetailType : IView & IViewSupportText
    
    var detail: DetailType { set get }
    
}

public extension IViewSupportDetail {
    
    @inlinable
    @discardableResult
    func detail(_ value: DetailType) -> Self {
        self.detail = value
        return self
    }
    
    @inlinable
    @discardableResult
    func detail(_ value: () -> DetailType) -> Self {
        return self.detail(value())
    }

    @inlinable
    @discardableResult
    func detail(_ value: (Self) -> DetailType) -> Self {
        return self.detail(value(self))
    }
    
}

public extension IViewSupportDetail where Self : IComposite, BodyType : IViewSupportDetail {
    
    @inlinable
    var detail: BodyType.DetailType {
        set { self.body.detail = newValue }
        get { self.body.detail }
    }
    
}
