//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class PositionPart {
        
        public var mode: Mode
        public var content: ILayoutPart
        
        public init(
            mode: Mode,
            content: ILayoutPart
        ) {
            self.mode = mode
            self.content = content
        }
        
    }
    
}

extension CompositionLayout.PositionPart : ILayoutPart {
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.size(available: bounds.size)
        switch self.mode {
        case .topLeft: return self.content.layout(bounds: Rect(topLeft: bounds.topLeft, size: size))
        case .top: return self.content.layout(bounds: Rect(top: bounds.top, size: size))
        case .topRight: return self.content.layout(bounds: Rect(topRight: bounds.topRight, size: size))
        case .left: return self.content.layout(bounds: Rect(left: bounds.left, size: size))
        case .center: return self.content.layout(bounds: Rect(center: bounds.center, size: size))
        case .right: return self.content.layout(bounds: Rect(right: bounds.right, size: size))
        case .bottomLeft: return self.content.layout(bounds: Rect(bottomLeft: bounds.bottomLeft, size: size))
        case .bottom: return self.content.layout(bounds: Rect(bottom: bounds.bottom, size: size))
        case .bottomRight: return self.content.layout(bounds: Rect(bottomRight: bounds.bottomRight, size: size))
        }
    }
    
    public func size(available: Size) -> Size {
        return self.content.size(available: available)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return self.content.views(bounds: bounds)
    }
    
}
