//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Bubble {
        
        public var content: IUICompositionLayoutEntity
        public var bubble: IUICompositionLayoutEntity
        
        public init(
            content: IUICompositionLayoutEntity,
            bubble: IUICompositionLayoutEntity
        ) {
            self.content = content
            self.bubble = bubble
        }
        
    }
    
}

extension UI.Layout.Composition.Bubble : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.content.invalidate()
        self.bubble.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.content.invalidate(view)
        self.bubble.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
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
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.bubble.views(bounds: bounds) + self.content.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Bubble {
    
    @inlinable
    static func bubble(
        content: IUICompositionLayoutEntity,
        bubble: IUICompositionLayoutEntity
    ) -> Self {
        return .init(content: content, bubble: bubble)
    }
    
}
