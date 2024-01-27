//
//  KindKit
//

import KindText

public protocol IViewSupportEditPlaceholder : AnyObject {
    
    var placeholderStyle: Style { set get }
    
    var placeholderText: Text { set get }
    
}

public extension IViewSupportEditPlaceholder {
    
    @inlinable
    @discardableResult
    func placeholderStyle(_ value: Style) -> Self {
        self.placeholderStyle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderStyle(on: () -> Style) -> Self {
        self.placeholderStyle = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholderStyle(on: (Self) -> Style) -> Self {
        self.placeholderStyle = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderText(_ value: Text) -> Self {
        self.placeholderText = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderText(on: () -> Text) -> Self {
        self.placeholderText = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholderText(on: (Self) -> Text) -> Self {
        self.placeholderText = on(self)
        return self
    }
    
}

public extension IViewSupportEditPlaceholder where Self : CompositorTrait, Body : IViewSupportEditPlaceholder {
    
    @inlinable
    var placeholderStyle: Style {
        set { self.body.placeholderStyle = newValue }
        get { self.body.placeholderStyle }
    }
    
    @inlinable
    var placeholderText: Text {
        set { self.body.placeholderText = newValue }
        get { self.body.placeholderText }
    }
    
}
