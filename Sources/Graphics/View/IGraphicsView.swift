//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public protocol IGraphicsView : IView, IViewLockable, IViewColorable, IViewAlphable {
    
    var width: StaticSizeBehaviour { set get }
    
    var height: StaticSizeBehaviour { set get }
    
    var canvas: IGraphicsCanvas { set get }
    
    func setNeedRedraw()
    
    @discardableResult
    func width(_ value: StaticSizeBehaviour) -> Self
    
    @discardableResult
    func height(_ value: StaticSizeBehaviour) -> Self
    
    @discardableResult
    func canvas(_ value: IGraphicsCanvas) -> Self

}
