//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum AnimatedImageViewRepeat {
    case loops(_ count: Int)
    case infinity
}

public enum AnimatedImageViewMode {
    case origin
    case aspectFit
    case aspectFill
}

public protocol IAnimatedImageView : IView, IViewColorable, IViewTintColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var width: DimensionBehaviour? { set get }
    
    var height: DimensionBehaviour? { set get }
    
    var aspectRatio: Float? { set get }
    
    var images: [Image] { set get }
    
    var duration: TimeInterval { set get }
    
    var `repeat`: AnimatedImageViewRepeat { set get }
    
    var mode: AnimatedImageViewMode { set get }
    
    var isAnimating: Bool { get }
    
    @discardableResult
    func start() -> Self

    @discardableResult
    func stop() -> Self
    
    @discardableResult
    func width(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self
    
    @discardableResult
    func images(_ value: [Image]) -> Self
    
    @discardableResult
    func duration(_ value: TimeInterval) -> Self
    
    @discardableResult
    func `repeat`(_ value: AnimatedImageViewRepeat) -> Self
    
    @discardableResult
    func mode(_ value: AnimatedImageViewMode) -> Self

}
