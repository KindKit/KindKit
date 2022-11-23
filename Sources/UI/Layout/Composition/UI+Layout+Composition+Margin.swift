//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Margin {
        
        public let inset: Inset
        public var entity: IUICompositionLayoutEntity
        
        public init(
            inset: Inset = .zero,
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
    public func layout(bounds: Rect) -> Size {
        let size = self.entity.layout(
            bounds: bounds.inset(self.inset)
        )
        if size.isZero == true {
            return size
        }
        return size.inset(-self.inset)
    }
    
    public func size(available: Size) -> Size {
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
    ) -> UI.Layout.Composition.Margin {
        return .init(
            inset: inset,
            entity: entity
        )
    }
    
}
