//
//  KindKit
//

import Foundation

public extension IUIWidgetView where Body == UI.View.Bar {
    
    @inlinable
    var placement: UI.View.Bar.Placement {
        set { self.body.placement = newValue }
        get { self.body.placement }
    }
    
    @inlinable
    var size: Double? {
        set { self.body.size = newValue }
        get { self.body.size }
    }
    
    @inlinable
    var safeArea: Inset {
        set { self.body.safeArea = newValue }
        get { self.body.safeArea }
    }
    
    @inlinable
    var separator: IUIView? {
        set { self.body.separator = newValue }
        get { self.body.separator }
    }
    
    @inlinable
    @discardableResult
    func placement(_ value: UI.View.Bar.Placement) -> Self {
        self.body.placement = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: Double?) -> Self {
        self.body.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: Inset) -> Self {
        self.body.safeArea = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separator(_ value: IUIView?) -> Self {
        self.body.separator = value
        return self
    }
    
}
