//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class LayoutPart {
        
        public var content: ILayout
        
        public init(
            _ content: ILayout
        ) {
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.LayoutPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return self.content.layout(bounds: bounds)
    }
    
    public func size(available: Size) -> Size {
        return self.content.size(available: available)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
