//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct HFill {
        
        public var entity: IUICompositionLayoutEntity
        
        public init(
            _ entity: IUICompositionLayoutEntity
        ) {
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.HFill : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.entity.layout(bounds: bounds)
        return .init(
            width: bounds.width,
            height: size.height
        )
    }
    
    public func size(available: Size) -> Size {
        let size = self.entity.size(available: available)
        return Size(
            width: available.width,
            height: size.height
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HFill {
    
    @inlinable
    static func hFill(
        _ entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.HFill {
        return .init(entity)
    }
    
}
