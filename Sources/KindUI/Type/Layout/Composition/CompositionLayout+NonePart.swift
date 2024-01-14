//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class NonePart {
        
        public init() {
        }
        
    }
    
}

extension CompositionLayout.NonePart : ILayoutPart {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IView) {
    }
    
    @discardableResult
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
