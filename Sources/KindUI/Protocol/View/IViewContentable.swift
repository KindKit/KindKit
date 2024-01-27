//
//  KindKit
//

import KindGraphics

public protocol IViewContentable : AnyObject {
    
    associatedtype ContentType
    
    var content: ContentType? { set get }
    
}

public extension IViewContentable where Self : IComposite, BodyType : IViewContentable {
    
    @inlinable
    var content: BodyType.ContentType? {
        set { self.body.content = newValue }
        get { self.body.content }
    }
    
}

public extension IViewContentable {
    
    @inlinable
    @discardableResult
    func content(_ value: ContentType?) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> ContentType?) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> ContentType?) -> Self {
        return self.content(value(self))
    }
    
}
