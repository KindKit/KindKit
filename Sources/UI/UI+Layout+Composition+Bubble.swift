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
    
    public func invalidate(item: UI.Layout.Item) {
        self.content.invalidate(item: item)
        self.bubble.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.bubble.layout(bounds: bounds)
        return size
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        let items = self.content.items(bounds: bounds)
        if items.isEmpty == true {
            return []
        }
        return self.bubble.items(bounds: bounds) + items
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
