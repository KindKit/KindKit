//
//  KindKit
//

import KindMath

public protocol ILayoutPart : AnyObject {
    
    func invalidate()
    
    func invalidate(_ view: IView)
    
    @discardableResult
    func layout(bounds: Rect) -> Size
    
    func size(available: Size) -> Size
    
    func views(bounds: Rect) -> [IView]
    
}
