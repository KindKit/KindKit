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
    func image(on: () -> Image) -> Self {
        self.image = on()
        return self
    }

    @inlinable 
    @discardableResult
    func image(on: (Self) -> Image) -> Self {
        self.image = on(self)
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
    func mode(on: () -> ImageMode) -> Self {
        self.mode = on()
        return self
    }

    @inlinable 
    @discardableResult
    func mode(on: (Self) -> ImageMode) -> Self {
        self.mode = on(self)
        return self
    }
    
}

public extension IViewSupportImage where Self : CompositorTrait, Body : IViewSupportImage {
    
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
