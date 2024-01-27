//
//  KindKit
//

import KindGraphics

public protocol IViewSupportImage : AnyObject {
    
    var image: Image { set get }
    
    var mode: ImageMode { set get }
    
}

public extension IViewSupportImage {
    
    @inlinable
    @discardableResult
    func image(_ value: Image) -> Self {
        self.image = value
        return self
    }

    @inlinable 
    @discardableResult
    func image(_ value: () -> Image) -> Self {
        self.image = value()
        return self
    }

    @inlinable 
    @discardableResult
    func image(_ value: (Self) -> Image) -> Self {
        self.image = value(self)
        return self
    }

    @inlinable 
    @discardableResult
    func mode(_ value: ImageMode) -> Self {
        self.mode = value
        return self
    }

    @inlinable 
    @discardableResult
    func mode(_ value: () -> ImageMode) -> Self {
        self.mode = value()
        return self
    }

    @inlinable 
    @discardableResult
    func mode(_ value: (Self) -> ImageMode) -> Self {
        self.mode = value(self)
        return self
    }
    
}

public extension IViewSupportImage where Self : IComposite, BodyType : IViewSupportImage {
    
    @inlinable
    var image: Image {
        set { self.body.image = newValue }
        get { self.body.image }
    }
    
    @inlinable
    var mode: ImageMode {
        set { self.body.mode = newValue }
        get { self.body.mode }
    }
    
}
