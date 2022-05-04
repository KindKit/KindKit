//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IEmptyView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var aspectRatio: Float? { set get }
    
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self
    
}
