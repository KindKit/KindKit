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
    
}

public extension ISpinnerView {
    
    @inlinable
    @discardableResult
    func size(_ value: StaticSizeBehaviour) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func activityColor(_ value: Color) -> Self {
        self.activityColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animating(_ value: Bool) -> Self {
        self.isAnimating = value
        return self
    }
    
}
