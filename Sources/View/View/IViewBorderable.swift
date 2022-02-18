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
    
    @discardableResult
    func border(_ value: ViewBorder) -> Self
    
}

extension IWidgetView where Body : IViewBorderable {
    
    public var border: ViewBorder {
        set(value) { self.body.border = value }
        get { return self.body.border }
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self.body.border(value)
        return self
    }
    
}
