//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Bubble {
        
        public var content: ICompositionLayoutEntity
        public var bubble: ICompositionLayoutEntity
        
        public init(
            content: ICompositionLayoutEntity,
            bubble: ICompositionLayoutEntity
        ) {
            self.content = content
            self.bubble = bubble
        }
        
    }
    
}

extension CompositionLayout.Bubble : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
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
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        let items = self.content.items(bounds: bounds)
        if items.isEmpty == true {
            return []
        }
        return self.bubble.items(bounds: bounds) + items
    }
    
}
