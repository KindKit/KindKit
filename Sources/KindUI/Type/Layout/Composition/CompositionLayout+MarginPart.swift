//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class MarginPart {
        
        public var inset: Inset
        public var content: ILayoutPart
        
        public init(
            inset: Inset,
            content: ILayoutPart
        ) {
            self.inset = inset
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.MarginPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(
            bounds: bounds.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func size(available: Size) -> Size {
        let size = self.content.size(
            available: available.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
