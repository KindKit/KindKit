//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class HFitPart {
        
        public var content: ILayoutPart
        
        public init(
            _ content: ILayoutPart
        ) {
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.HFitPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.size(available: .init(
            width: .infinity,
            height: bounds.height
        ))
        return self.content.layout(bounds: .init(
            origin: bounds.origin,
            size: size
        ))
    }
    
    public func size(available: Size) -> Size {
        return self.content.size(available: .init(
            width: .infinity,
            height: available.height
        ))
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
