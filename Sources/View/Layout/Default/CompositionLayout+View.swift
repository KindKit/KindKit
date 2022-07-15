//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct View {
        
        public let item: LayoutItem
        
        public init(
            _ item: LayoutItem
        ) {
            self.item = item
        }
        
        public init(
            _ view: IView
        ) {
            self.item = LayoutItem(view: view)
        }
        
    }
    
}

extension CompositionLayout.View : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        self.item.frame = bounds
        return bounds.size
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.item.size(available: available)
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return [ self.item ]
    }
    
}
