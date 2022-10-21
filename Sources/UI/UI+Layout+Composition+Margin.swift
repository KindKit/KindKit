//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Margin {
        
        public let inset: InsetFloat
        public var entity: IUICompositionLayoutEntity
        
        public init(
            inset: InsetFloat = .zero,
            entity: IUICompositionLayoutEntity
        ) {
            self.inset = inset
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.Margin : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(item: UI.Layout.Item) {
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
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return self.entity.items(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Margin {
    
    @inlinable
    static func margin(
        inset: InsetFloat,
        entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.Margin {
        return .init(
            inset: inset,
            entity: entity
        )
    }
    
}
