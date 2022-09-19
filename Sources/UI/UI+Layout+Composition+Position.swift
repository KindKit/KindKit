//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Position {
        
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

extension UI.Layout.Composition.Position : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
        self.entity.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let size = self.entity.size(available: bounds.size)
        switch self.mode {
        case .topLeft: return self.entity.layout(bounds: RectFloat(topLeft: bounds.topLeft, size: size))
        case .top: return self.entity.layout(bounds: RectFloat(top: bounds.top, size: size))
        case .topRight: return self.entity.layout(bounds: RectFloat(topRight: bounds.topRight, size: size))
        case .left: return self.entity.layout(bounds: RectFloat(left: bounds.left, size: size))
        case .center: return self.entity.layout(bounds: RectFloat(center: bounds.center, size: size))
        case .right: return self.entity.layout(bounds: RectFloat(right: bounds.right, size: size))
        case .bottomLeft: return self.entity.layout(bounds: RectFloat(bottomLeft: bounds.bottomLeft, size: size))
        case .bottom: return self.entity.layout(bounds: RectFloat(bottom: bounds.bottom, size: size))
        case .bottomRight: return self.entity.layout(bounds: RectFloat(bottomRight: bounds.bottomRight, size: size))
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.entity.size(available: available)
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return self.entity.items(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Position {
    
    @inlinable
    static func position(
        mode: UI.Layout.Composition.Position.Mode,
        entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.Position {
        return .init(
            mode: mode,
            entity: entity
        )
    }
    
}
