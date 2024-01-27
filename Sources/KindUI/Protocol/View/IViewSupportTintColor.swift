//
//  KindKit
//

import KindGraphics

public protocol IViewSupportTintColor : AnyObject {
    
    var tintColor: Color? { set get }
    
}

public extension IViewSupportTintColor where Self : IComposite, BodyType : IViewSupportTintColor {
    
    @inlinable
    var tintColor: Color? {
        set { self.body.tintColor = newValue }
        get { self.body.tintColor }
    }
    
}

public extension IViewSupportTintColor {
    
    @inlinable
    @discardableResult
    func tintColor(_ value: Color?) -> Self {
        self.tintColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func tintColor(_ value: () -> Color?) -> Self {
        return self.tintColor(value())
    }

    @inlinable
    @discardableResult
    func tintColor(_ value: (Self) -> Color?) -> Self {
        return self.tintColor(value(self))
    }
    
}
