//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct VFit {
        
        public var entity: IUICompositionLayoutEntity
        
        public init(
            _ entity: IUICompositionLayoutEntity
        ) {
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.VFit : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return self.entity.layout(bounds: bounds)
    }
    
    public func size(available: Size) -> Size {
        return self.entity.size(available: .init(
            width: available.width,
            height: .infinity
        ))
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VFit {
    
    @inlinable
    static func vFit(
        _ entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.VFit {
        return .init(entity)
    }
    
}
