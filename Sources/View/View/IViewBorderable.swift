//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum ViewBorder : Equatable {
    case none
    case manual(width: Float, color: Color)
}

public protocol IViewBorderable : AnyObject {
    
    var border: ViewBorder { set get }
    
}

public extension IViewBorderable {
    
    @inlinable
    @discardableResult
    func border(_ value: ViewBorder) -> Self {
        self.border = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewBorderable {
    
    @inlinable
    var border: ViewBorder {
        set(value) { self.body.border = value }
        get { return self.body.border }
    }
    
    @inlinable
    @discardableResult
    func border(_ value: ViewBorder) -> Self {
        self.body.border(value)
        return self
    }
    
}
