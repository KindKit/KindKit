//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ICellView : IView, IViewHighlightable, IViewLockable, IViewSelectable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var shouldHighlighting: Bool { set get }
    
    var shouldPressed: Bool { set get }
    
}

public extension ICellView {
    
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
