//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IExternalView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var aspectRatio: Float? { set get }
    
    var external: NativeView { set get }
    
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self
    
    @discardableResult
    func external(_ value: NativeView) -> Self
    
}
