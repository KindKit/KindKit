//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class SpacePart {
        
        public var size: StaticSize
        
        public init(
            width: StaticSize.Dimension,
            height: StaticSize.Dimension
        ) {
            self.size = .init(width, height)
        }
        
    }
    
}

extension CompositionLayout.SpacePart : ILayoutPart {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return self.size.apply(available: bounds.size)
    }
    
    public func size(available: Size) -> Size {
        return self.size.apply(available: available)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return []
    }
    
}
