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

public protocol IAnimatedImageView : IView, IViewDynamicSizeBehavioural, IViewColorable, IViewTintColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
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
    func `repeat`(_ value: AnimatedImageViewRepeat) -> Self
    
    @discardableResult
    func mode(_ value: AnimatedImageViewMode) -> Self

}

public extension IAnimatedImageView {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func images(_ value: [Image]) -> Self {
        self.images = value
        return self
    }
    
    @inlinable
    @discardableResult
    func duration(_ value: TimeInterval) -> Self {
        self.duration = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `repeat`(_ value: AnimatedImageViewRepeat) -> Self {
        self.repeat = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: AnimatedImageViewMode) -> Self {
        self.mode = value
        return self
    }
    
}
