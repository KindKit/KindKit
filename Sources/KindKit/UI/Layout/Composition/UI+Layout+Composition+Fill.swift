//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Fill {
        
        public var entity: IUICompositionLayoutEntity
        
        public init(
            _ entity: IUICompositionLayoutEntity
        ) {
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.Fill : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        let size = self.entity.layout(bounds: bounds)
        return size
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        return available
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Fill {
    
    @inlinable
    static func fill(
        _ entity: IUICompositionLayoutEntity
    ) -> Self {
        return .init(entity)
    }
    
}
