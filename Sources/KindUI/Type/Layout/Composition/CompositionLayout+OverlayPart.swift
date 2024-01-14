//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class OverlayPart {
        
        public var content: ILayoutPart
        public var overlay: ILayoutPart
        
        public init(
            content: ILayoutPart,
            overlay: ILayoutPart
        ) {
            self.content = content
            self.overlay = overlay
        }
        
    }
    
}

extension CompositionLayout.OverlayPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
        self.overlay.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
        self.overlay.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.overlay.layout(bounds: .init(
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
        return self.content.views(bounds: bounds) + self.overlay.views(bounds: bounds)
    }
    
}
