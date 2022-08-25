//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public protocol IGraphicsView : IView, IViewStaticSizeBehavioural, IViewLockable, IViewColorable, IViewAlphable {
    
    var canvas: IGraphicsCanvas { set get }
    
    func setNeedRedraw()
    
}

public extension IGraphicsView {
    
    @inlinable
    @discardableResult
    func canvas(_ value: IGraphicsCanvas) -> Self {
        self.canvas = value
        return self
    }
    
}
