//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Bubble {
        
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
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.bubble.layout(bounds: bounds)
        return size
    }
    
    public func size(available: Size) -> Size {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        let views = self.content.views(bounds: bounds)
        if views.isEmpty == true {
            return []
        }
        return self.bubble.views(bounds: bounds) + views
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Bubble {
    
    @inlinable
    static func bubble(
        content: IUICompositionLayoutEntity,
        bubble: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.Bubble {
        return .init(content: content, bubble: bubble)
    }
    
}
