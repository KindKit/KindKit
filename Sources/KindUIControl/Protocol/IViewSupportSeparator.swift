//
//  KindKit
//

import KindUI

public protocol IViewSupportSeparator : AnyObject {
    
    associatedtype SeparatorType : IView
    
    var separator: SeparatorType { set get }
    
}

public extension IViewSupportSeparator {
    
    @inlinable
    @discardableResult
    func separator(_ value: SeparatorType) -> Self {
        self.separator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separator(_ value: () -> SeparatorType) -> Self {
        return self.separator(value())
    }

    @inlinable
    @discardableResult
    func separator(_ value: (Self) -> SeparatorType) -> Self {
        return self.separator(value(self))
    }
    
}

public extension IViewSupportSeparator where Self : IComposite, BodyType : IViewSupportSeparator {
    
    @inlinable
    var separator: BodyType.SeparatorType {
        set { self.body.separator = newValue }
        get { self.body.separator }
    }
    
}
