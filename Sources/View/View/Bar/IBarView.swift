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
    
    @discardableResult
    func placement(_ value: BarViewPlacement) -> Self
    
    @discardableResult
    func size(_ value: Float?) -> Self
    
    @discardableResult
    func safeArea(_ value: InsetFloat) -> Self
    
    @discardableResult
    func separatorView(_ value: IView?) -> Self

}
