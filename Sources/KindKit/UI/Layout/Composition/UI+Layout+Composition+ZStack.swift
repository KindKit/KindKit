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
    public func layout(bounds: Rect) -> KindKit.Size {
        var maxSize = KindKit.Size.zero
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
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        var maxSize = KindKit.Size.zero
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
    ) -> Self {
        return .init(entities)
    }
    
}
