//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public protocol IGraphicsView : IView, IViewLockable, IViewColorable, IViewAlphable {
    
    var width: DimensionBehaviour { set get }
    
    var height: DimensionBehaviour { set get }
    
    var canvas: IGraphicsCanvas { set get }
    
    func setNeedRedraw()
    
    @discardableResult
    func width(_ value: DimensionBehaviour) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour) -> Self
    
    @discardableResult
    func canvas(_ value: IGraphicsCanvas) -> Self

}
