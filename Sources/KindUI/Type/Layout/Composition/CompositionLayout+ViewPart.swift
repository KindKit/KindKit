//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class ViewPart {
        
        public var content: IView
        
        public init(
            _ content: IView
        ) {
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.ViewPart : ILayoutPart {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        self.content.frame = bounds
        return bounds.size
    }
    
    public func size(available: Size) -> Size {
        return self.content.size(available: available)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return [ self.content ]
    }
    
}
