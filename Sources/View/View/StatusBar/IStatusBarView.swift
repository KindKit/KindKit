//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStatusBarView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var height: Float { set get }
    
}

public extension IStatusBarView {
    
    @inlinable
    @discardableResult
    func height(_ value: Float) -> Self {
        self.height = value
        return self
    }
    
}
