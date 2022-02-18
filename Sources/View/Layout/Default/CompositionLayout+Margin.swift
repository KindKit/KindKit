//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Margin {
        
        public let inset: InsetFloat
        public var entity: ICompositionLayoutEntity
        
        public init(
            inset: InsetFloat,
            entity: ICompositionLayoutEntity
        ) {
            self.inset = inset
            self.entity = entity
        }
        
    }
    
}

extension CompositionLayout.Margin : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        self.entity.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let size = self.entity.layout(
            bounds: bounds.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let size = self.entity.size(
            available: available.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return self.entity.items(bounds: bounds)
    }
    
}
