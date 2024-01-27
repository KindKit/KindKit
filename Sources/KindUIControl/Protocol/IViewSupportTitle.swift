//
//  KindKit
//

import KindUI

public protocol IViewSupportTitle : AnyObject {
    
    associatedtype TitleType : IView & IViewSupportText
    
    var title: TitleType { set get }
    
}

public extension IViewSupportTitle {
    
    @inlinable
    @discardableResult
    func title(_ value: TitleType) -> Self {
        self.title = value
        return self
    }
    
    @inlinable
    @discardableResult
    func title(_ value: () -> TitleType) -> Self {
        return self.title(value())
    }

    @inlinable
    @discardableResult
    func title(_ value: (Self) -> TitleType) -> Self {
        return self.title(value(self))
    }
    
}

public extension IViewSupportTitle where Self : IComposite, BodyType : IViewSupportTitle {
    
    @inlinable
    var title: BodyType.TitleType {
        set { self.body.title = newValue }
        get { self.body.title }
    }
    
}
