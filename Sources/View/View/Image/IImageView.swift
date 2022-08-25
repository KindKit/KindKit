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

public protocol IImageView : IView, IViewDynamicSizeBehavioural, IViewColorable, IViewTintColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var aspectRatio: Float? { set get }
    
    var image: Image { set get }
    
    var mode: ImageViewMode { set get }
    
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self
    
    @discardableResult
    func image(_ value: Image) -> Self
    
    @discardableResult
    func mode(_ value: ImageViewMode) -> Self

}

public extension IImageView {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func image(_ value: Image) -> Self {
        self.image = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: ImageViewMode) -> Self {
        self.mode = value
        return self
    }
    
}
