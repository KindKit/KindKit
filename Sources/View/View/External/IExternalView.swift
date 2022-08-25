//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IExternalView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var aspectRatio: Float? { set get }
    
    var external: NativeView { set get }
    
}

public extension IExternalView {

    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func external(_ value: NativeView) -> Self {
        self.external = value
        return self
    }
    
}
