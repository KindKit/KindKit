//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

public protocol IBlurView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var style: UIBlurEffect.Style { set get }
    
    @discardableResult
    func style(_ value: UIBlurEffect.Style) -> Self
    
}

#endif
