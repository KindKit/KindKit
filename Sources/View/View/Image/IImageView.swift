//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum ImageViewMode {
    case origin
    case aspectFit
    case aspectFill
}

public protocol IImageView : IView, IViewColorable, IViewTintColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var width: DimensionBehaviour? { set get }
    
    var height: DimensionBehaviour? { set get }
    
    var aspectRatio: Float? { set get }
    
    var image: Image { set get }
    
    var mode: ImageViewMode { set get }
    
    @discardableResult
    func width(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self
    
    @discardableResult
    func image(_ value: Image) -> Self
    
    @discardableResult
    func mode(_ value: ImageViewMode) -> Self

}
