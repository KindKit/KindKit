//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VFill {
        
        public var entity: IUICompositionLayoutEntity
        
        public init(
            _ entity: IUICompositionLayoutEntity
        ) {
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.VFill : IUICompositionLayoutEntity {
    
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
        let size = self.entity.size(available: available)
        return .init(
            width: size.width,
            height: available.height
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VFill {
    
    @inlinable
    static func vFill(
        _ entity: IUICompositionLayoutEntity
    ) -> Self {
        return .init(entity)
    }
    
}
