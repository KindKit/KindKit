//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct None {
        
        public init() {
        }
        
    }
    
}

extension CompositionLayout.None : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        return .zero
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return .zero
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return []
    }
    
}
