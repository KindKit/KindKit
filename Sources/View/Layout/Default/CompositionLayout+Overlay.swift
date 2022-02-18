//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Overlay {
        
        public var content: ICompositionLayoutEntity
        public var overlay: ICompositionLayoutEntity
        
        public init(
            content: ICompositionLayoutEntity,
            overlay: ICompositionLayoutEntity
        ) {
            self.content = content
            self.overlay = overlay
        }
        
    }
    
}

extension CompositionLayout.Overlay : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        self.content.invalidate(item: item)
        self.overlay.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.overlay.layout(bounds: bounds)
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
        return items + self.overlay.items(bounds: bounds)
    }
    
}
