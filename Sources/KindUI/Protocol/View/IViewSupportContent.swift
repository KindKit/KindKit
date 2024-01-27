//
//  KindKit
//

import KindGraphics

public protocol IViewSupportContent : AnyObject {
    
    associatedtype ContentType
    
    var content: ContentType { set get }
    
}

public extension IViewSupportContent where Self : IComposite, BodyType : IViewSupportContent {
    
    @inlinable
    var content: BodyType.ContentType {
        set { self.body.content = newValue }
        get { self.body.content }
    }
    
}

public extension IViewSupportContent {
    
    @inlinable
    @discardableResult
    func content(_ value: ContentType) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> ContentType) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> ContentType) -> Self {
        return self.content(value(self))
    }
    
}
