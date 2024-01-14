//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class SizePart {
        
        public var content: ILayoutPart
        public var size: KindUI.DynamicSize
        
        public init(
            content: ILayoutPart,
            size: KindUI.DynamicSize
        ) {
            self.content = content
            self.size = size
        }
        
    }
    
}

extension CompositionLayout.SizePart : ILayoutPart {
    
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
        return self.size.apply(
            available: available,
            size: { available in
                return self.content.size(available: available)
            }
        )
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
