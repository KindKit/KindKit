//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IControlView : IView, IViewHighlightable, IViewLockable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var contentSize: SizeFloat { get }
    
    var shouldHighlighting: Bool { set get }
    
    var shouldPressed: Bool { set get }
    
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self
    
    @discardableResult
    func shouldPressed(_ value: Bool) -> Self
    
    @discardableResult
    func onPressed(_ value: (() -> Void)?) -> Self
    
}

public extension IControlView {
    
    @inlinable
    @discardableResult
    func shouldHighlighting(_ value: Bool) -> Self {
        self.shouldHighlighting = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldPressed(_ value: Bool) -> Self {
        self.shouldPressed = value
        return self
    }
    
}
