//
//  KindKit
//

import KindGraphics

public protocol IViewSupportStyleSheet : AnyObject {
    
    associatedtype StyleSheet
    
    @discardableResult
    func apply(_ styleSheet: StyleSheet) -> Self
    
}

public extension IViewSupportStyleSheet where Self : IComposite, BodyType : IViewSupportStyleSheet {
    
    @inlinable
    @discardableResult
    func apply(_ styleSheet: BodyType.StyleSheet) -> Self {
        self.body.apply(styleSheet)
        return self
    }
    
}
