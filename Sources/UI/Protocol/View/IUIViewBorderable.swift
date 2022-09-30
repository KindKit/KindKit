//
//  KindKit
//

import Foundation

public protocol IUIViewBorderable : AnyObject {
    
    var border: UI.Border { set get }
    
}

public extension IUIViewBorderable {
    
    @inlinable
    @discardableResult
    func border(_ value: UI.Border) -> Self {
        self.border = value
        return self
    }
    
}

public extension IUIViewBorderable where Self : IUIWidgetView, Body : IUIViewBorderable {
    
    @inlinable
    var border: UI.Border {
        set { self.body.border = newValue }
        get { return self.body.border }
    }
    
}
