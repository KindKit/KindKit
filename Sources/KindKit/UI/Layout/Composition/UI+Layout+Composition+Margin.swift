//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Margin {
        
        public var inset: Inset
        public var entity: IUICompositionLayoutEntity
        
        public init(
            inset: Inset,
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
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        let size = self.entity.layout(
            bounds: bounds.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        let size = self.entity.size(
            available: available.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Margin {
    
    @inlinable
    static func margin(
        inset: Inset,
        entity: IUICompositionLayoutEntity
    ) -> Self {
        return .init(
            inset: inset,
            entity: entity
        )
    }
    
}
