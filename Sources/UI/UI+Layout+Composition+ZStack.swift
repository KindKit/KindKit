//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct ZStack {
        
        public var mode: Mode
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            mode: Mode = [],
            entities: [IUICompositionLayoutEntity]
        ) {
            self.mode = mode
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
    
    public func invalidate(item: UI.Layout.Item) {
        for entity in self.entities {
            entity.invalidate(item: item)
        }
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        var maxSize = SizeFloat.zero
        if self.mode.contains(.horizontal) == true {
            maxSize.width = bounds.width
        }
        if self.mode.contains(.vertical) == true {
            maxSize.height = bounds.height
        }
        for entity in self.entities {
            let size = entity.size(available: bounds.size)
            maxSize = maxSize.max(size)
        }
        for entity in self.entities {
            entity.layout(
                bounds: RectFloat(
                    topLeft: bounds.topLeft,
                    size: maxSize
                )
            )
        }
        return maxSize
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        var maxSize = SizeFloat.zero
        if self.mode.contains(.horizontal) == true {
            maxSize.width = available.width
        }
        if self.mode.contains(.vertical) == true {
            maxSize.height = available.height
        }
        for entity in self.entities {
            let size = entity.size(available: available)
            maxSize = maxSize.max(size)
        }
        return maxSize
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        var items: [UI.Layout.Item] = []
        for entity in self.entities {
            items.append(contentsOf: entity.items(bounds: bounds))
        }
        return items
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.ZStack {
    
    @inlinable
    static func zStack(
        mode: UI.Layout.Composition.ZStack.Mode = [],
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.ZStack {
        return .init(
            mode: mode,
            entities: entities
        )
    }
    
}
