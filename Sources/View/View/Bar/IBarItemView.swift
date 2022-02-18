//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IBarItemViewDelegate : AnyObject {
    
    func pressed(barItemView: IBarItemView)
    
}

public protocol IBarItemView : IView, IViewSelectable, IViewHighlightable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var delegate: IBarItemViewDelegate? { set get }
    
    var contentInset: InsetFloat { set get }
    
    var contentView: IView { set get }
    
    @discardableResult
    func contentInset(_ value: InsetFloat) -> Self

}
