//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IProgressView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var progressColor: Color { set get }
    
    var trackColor: Color { set get }
    
    var progress: Float { set get }
    
}

public extension IProgressView {
    
    @inlinable
    @discardableResult
    func progressColor(_ value: Color) -> Self {
        self.progressColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trackColor(_ value: Color) -> Self {
        self.trackColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progress(_ value: Float) -> Self {
        self.progress = value
        return self
    }
    
}
