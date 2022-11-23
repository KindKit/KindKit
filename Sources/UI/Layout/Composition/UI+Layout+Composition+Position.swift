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
    
    public func invalidate() {
        self.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.entity.size(available: bounds.size)
        switch self.mode {
        case .topLeft: return self.entity.layout(bounds: Rect(topLeft: bounds.topLeft, size: size))
        case .top: return self.entity.layout(bounds: Rect(top: bounds.top, size: size))
        case .topRight: return self.entity.layout(bounds: Rect(topRight: bounds.topRight, size: size))
        case .left: return self.entity.layout(bounds: Rect(left: bounds.left, size: size))
        case .center: return self.entity.layout(bounds: Rect(center: bounds.center, size: size))
        case .right: return self.entity.layout(bounds: Rect(right: bounds.right, size: size))
        case .bottomLeft: return self.entity.layout(bounds: Rect(bottomLeft: bounds.bottomLeft, size: size))
        case .bottom: return self.entity.layout(bounds: Rect(bottom: bounds.bottom, size: size))
        case .bottomRight: return self.entity.layout(bounds: Rect(bottomRight: bounds.bottomRight, size: size))
        }
    }
    
    public func size(available: Size) -> Size {
        return self.entity.size(available: available)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
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
