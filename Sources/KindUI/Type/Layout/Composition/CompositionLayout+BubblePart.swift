//
//  KindKit
//

import KindMath

public extension CompositionLayout {
    
    final class BubblePart {
        
        public var content: ILayoutPart
        public var bubble: ILayoutPart
        
        public init(
            content: ILayoutPart,
            bubble: ILayoutPart
        ) {
            self.content = content
            self.bubble = bubble
        }
        
    }
    
}

extension CompositionLayout.BubblePart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
        self.bubble.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
        self.bubble.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.bubble.layout(bounds: .init(
            topLeft: bounds.topLeft,
            size: size
        ))
        return size
    }
    
    public func size(available: Size) -> Size {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.bubble.views(bounds: bounds) + self.content.views(bounds: bounds)
    }
    
}
