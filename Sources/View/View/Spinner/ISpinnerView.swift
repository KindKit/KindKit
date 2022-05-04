//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ISpinnerView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var size: StaticSizeBehaviour { set get }
    
    var activityColor: Color { set get }
    
    var isAnimating: Bool { set get }
    
    @discardableResult
    func size(_ value: StaticSizeBehaviour) -> Self
    
    @discardableResult
    func activityColor(_ value: Color) -> Self
    
    @discardableResult
    func animating(_ value: Bool) -> Self
    
}
