//
//  KindKit
//

import KindUI

public protocol IViewSupportIcon : AnyObject {
    
    associatedtype IconType : IView & IViewSupportImage
    
    var icon: IconType { set get }
    
}

public extension IViewSupportIcon {
    
    @inlinable
    @discardableResult
    func icon(_ value: IconType) -> Self {
        self.icon = value
        return self
    }
    
    @inlinable
    @discardableResult
    func icon(_ value: () -> IconType) -> Self {
        return self.icon(value())
    }

    @inlinable
    @discardableResult
    func icon(_ value: (Self) -> IconType) -> Self {
        return self.icon(value(self))
    }
    
}

public extension IViewSupportIcon where Self : IComposite, BodyType : IViewSupportIcon {
    
    @inlinable
    var icon: BodyType.IconType {
        set { self.body.icon = newValue }
        get { self.body.icon }
    }
    
}
