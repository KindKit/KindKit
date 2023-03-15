//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class HFit {
        
        public var entity: IUICompositionLayoutEntity
        
        public init(
            _ entity: IUICompositionLayoutEntity
        ) {
            self.entity = entity
        }
        
    }
    
}

extension UI.Layout.Composition.HFit : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        let size = self.entity.size(available: .init(
            width: .infinity,
            height: bounds.height
        ))
        return self.entity.layout(bounds: .init(
            origin: bounds.origin,
            size: size
        ))
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        return self.entity.size(available: .init(
            width: .infinity,
            height: available.height
        ))
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HFit {
    
    @inlinable
    static func hFit(
        _ entity: IUICompositionLayoutEntity
    ) -> Self {
        return .init(entity)
    }
    
}
