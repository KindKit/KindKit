//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Layout {
        
        public let layout: ILayout
        
        public init(
            _ layout: ILayout
        ) {
            self.layout = layout
        }
        
    }
    
}

extension CompositionLayout.Layout : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        self.layout.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        return self.layout.layout(bounds: bounds)
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.layout.size(available: available)
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return self.layout.items(bounds: bounds)
    }
    
}
