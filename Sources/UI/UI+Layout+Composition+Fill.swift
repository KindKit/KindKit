//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Fill {
        
        public var mode: Mode
        public var entity: IUICompositionLayoutEntity
        
        public init(
            mode: Mode,
            entity: IUICompositionLayoutEntity
        ) {
            self.mode = mode
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.Fill : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
        self.entity.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal:
            let size = self.entity.size(available: bounds.size)
            return self.entity.layout(
                bounds: RectFloat(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: size.height
                )
            )
        case .vertical:
            let size = self.entity.size(available: bounds.size)
            return self.entity.layout(
                bounds: RectFloat(
                    x: bounds.x,
                    y: bounds.y,
                    width: size.width,
                    height: bounds.height
                )
            )
        case .both:
            return self.entity.layout(bounds: bounds)
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal:
            let size = self.entity.size(available: available)
            return Size(
                width: available.width,
                height: size.height
            )
        case .vertical:
            let size = self.entity.size(available: available)
            return Size(
                width: size.width,
                height: available.height
            )
        case .both:
            return available
        }
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return self.entity.items(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Fill {
    
    @inlinable
    static func fill(
        mode: UI.Layout.Composition.Fill.Mode,
        entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.Fill {
        return .init(mode: mode, entity: entity)
    }
    
}
