//
//  KindKit
//

import KindMath

public extension CompositionLayout {
    
    final class VirtualViewPart {
        
        public var content: IView
        public var mode: Mode
        public var size: DynamicSize
        
        public init(
            content: IView,
            mode: Mode,
            size: DynamicSize
        ) {
            self.content = content
            self.mode = mode
            self.size = size
        }
        
    }
    
}

extension CompositionLayout.VirtualViewPart : ILayoutPart {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size: Size
        switch self.mode {
        case .horizontal:
            size = self.content.size(available: .init(
                width: .infinity,
                height: bounds.height
            ))
        case .vertical:
            size = self.content.size(available: .init(
                width: bounds.width,
                height: .infinity
            ))
        }
        self.content.frame = Rect(
            topLeft: bounds.topLeft,
            size: size
        )
        return bounds.size
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
        return [ self.content ]
    }
    
}
