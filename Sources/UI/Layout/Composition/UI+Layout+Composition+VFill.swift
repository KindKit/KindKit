//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct VFill {
        
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
    public func layout(bounds: Rect) -> Size {
        let size = self.entity.size(available: bounds.size)
        return self.entity.layout(
            bounds: Rect(
                x: bounds.x,
                y: bounds.y,
                width: size.width,
                height: bounds.height
            )
        )
    }
    
    public func size(available: Size) -> Size {
        let size = self.entity.size(available: available)
        return Size(
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
    ) -> UI.Layout.Composition.VFill {
        return .init(entity)
    }
    
}
