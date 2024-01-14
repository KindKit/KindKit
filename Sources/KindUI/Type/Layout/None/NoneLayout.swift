//
//  KindKit
//

import KindMath

public final class NoneLayout : ILayout {
    
    public weak var delegate: ILayoutDelegate?
    public weak var appearedView: IView?

    public init() {
    }
    
    public func layout(bounds: Rect) -> Size {
        return .zero
    }
    
    public func size(available: Size) -> Size {
        return .zero
    }
    
    public func views(bounds: Rect) -> [IView] {
        return []
    }
    
}
