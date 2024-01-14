//
//  KindKit
//

import KindGraphics

public protocol IViewBorderable : AnyObject {
    
    var border: Border { set get }
    
}

public extension IViewBorderable where Self : IWidgetView, Body : IViewBorderable {
    
    @inlinable
    var border: Border {
        set { self.body.border = newValue }
        get { self.body.border }
    }
    
}

public extension IViewBorderable {
    
    @inlinable
    @discardableResult
    func border(_ value: Border) -> Self {
        self.border = value
        return self
    }
    
    @inlinable
    @discardableResult
    func border(_ value: () -> Border) -> Self {
        return self.border(value())
    }

    @inlinable
    @discardableResult
    func border(_ value: (Self) -> Border) -> Self {
        return self.border(value(self))
    }
    
}
