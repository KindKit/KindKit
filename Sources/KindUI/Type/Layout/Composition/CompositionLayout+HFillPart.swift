//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class HFillPart {
        
        public var content: ILayoutPart
        
        public init(
            _ content: ILayoutPart
        ) {
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.HFillPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(bounds: bounds)
        return .init(
            width: bounds.width,
            height: size.height
        )
    }
    
    public func size(available: Size) -> Size {
        let size = self.content.size(available: available)
        return .init(
            width: available.width,
            height: size.height
        )
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
