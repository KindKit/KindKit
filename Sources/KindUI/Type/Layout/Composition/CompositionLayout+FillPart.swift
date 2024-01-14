//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class FillPart {
        
        public var content: ILayoutPart
        
        public init(
            _ content: ILayoutPart
        ) {
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.FillPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindMath.Size {
        return self.content.layout(bounds: bounds)
    }
    
    public func size(available: KindMath.Size) -> KindMath.Size {
        return available
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
