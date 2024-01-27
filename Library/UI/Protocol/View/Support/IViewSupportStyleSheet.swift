//
//  KindKit
//

import KindGraphics
import KindStyleSheet

public protocol IViewSupportStyleSheet : AnyObject {
    
    associatedtype StyleSheet : StyleSheetTrait
    
    @discardableResult
    func apply(_ styleSheet: StyleSheet) -> Self
    
}

public extension IViewSupportStyleSheet where Self : CompositorTrait, Body : IViewSupportStyleSheet {
    
    @inlinable
    @discardableResult
    func apply(_ styleSheet: Body.StyleSheet) -> Self {
        self.body.apply(styleSheet)
        return self
    }
    
}
