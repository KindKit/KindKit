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
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        switch self.mode {
        case .horizontal:
            let size = self.entity.size(available: bounds.size)
            return self.entity.layout(
                bounds: Rect(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: size.height
                )
            )
        case .vertical:
            let size = self.entity.size(available: bounds.size)
            return self.entity.layout(
                bounds: Rect(
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
    
    public func size(available: Size) -> Size {
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
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
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
