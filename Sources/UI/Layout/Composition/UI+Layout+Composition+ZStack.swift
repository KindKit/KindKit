//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class ZStack {
        
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            _ entities: [IUICompositionLayoutEntity]
        ) {
            self.entities = entities
        }
        
    }
    
}

extension UI.Layout.Composition.ZStack : IUICompositionLayoutEntity {
    
    public func invalidate() {
        for entity in self.entities {
            entity.invalidate()
        }
    }
    
    public func invalidate(_ view: IUIView) {
        for entity in self.entities {
            entity.invalidate(view)
        }
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        var maxSize = Size.zero
        for entity in self.entities {
            let size = entity.size(available: bounds.size)
            maxSize = maxSize.max(size)
        }
        for entity in self.entities {
            entity.layout(
                bounds: Rect(
                    topLeft: bounds.topLeft,
                    size: maxSize
                )
            )
        }
        return maxSize
    }
    
    public func size(available: Size) -> Size {
        var maxSize = Size.zero
        for entity in self.entities {
            let size = entity.size(available: available)
            maxSize = maxSize.max(size)
        }
        return maxSize
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        var views: [IUIView] = []
        for entity in self.entities {
            views.append(contentsOf: entity.views(bounds: bounds))
        }
        return views
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.ZStack {
    
    @inlinable
    static func zStack(
        _ entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.ZStack {
        return .init(entities)
    }
    
}
