//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStatusBarView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var height: Float { set get }
    
    @discardableResult
    func height(_ value: Float) -> Self
    
}
