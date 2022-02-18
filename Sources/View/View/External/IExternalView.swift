//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IExternalView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var width: DimensionBehaviour? { set get }
    
    var height: DimensionBehaviour? { set get }
    
    var aspectRatio: Float? { set get }
    
    var external: NativeView { set get }
    
    @discardableResult
    func width(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self
    
    @discardableResult
    func external(_ value: NativeView) -> Self
    
}
