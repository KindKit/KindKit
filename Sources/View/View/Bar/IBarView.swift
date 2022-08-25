//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum BarViewPlacement {
    
    case top
    case bottom
    
}

public protocol IBarView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var placement: BarViewPlacement { set get }
    
    var size: Float? { set get }
    
    var safeArea: InsetFloat { set get }
    
    var separatorView: IView? { set get }

}

public extension IBarView {
    
    @inlinable
    @discardableResult
    func placement(_ value: BarViewPlacement) -> Self {
        self.placement = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: Float?) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: InsetFloat) -> Self {
        self.safeArea = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separatorView(_ value: IView?) -> Self {
        self.separatorView = value
        return self
    }
    
}
