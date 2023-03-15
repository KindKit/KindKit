//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Size {
        
        public var entity: IUICompositionLayoutEntity
        public var size: UI.Size.Dynamic
        
        public init(
            entity: IUICompositionLayoutEntity,
            size: UI.Size.Dynamic
        ) {
            self.entity = entity
            self.size = size
        }
        
    }
    
}

extension UI.Layout.Composition.Size : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        return self.entity.layout(bounds: bounds)
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        return self.size.apply(
            available: available,
            size: { available in
                return self.entity.size(available: available)
            }
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Size {
    
    @inlinable
    static func size(
        entity: IUICompositionLayoutEntity,
        size: UI.Size.Dynamic
    ) -> Self {
        return .init(
            entity: entity,
            size: size
        )
    }
    
}
