//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VFlow {
        
        public var alignment: Alignment
        public var entitySpacing: Double
        public var lineSpacing: Double
        public var entities: [IUICompositionLayoutEntity]

        public init(
            alignment: Alignment = .center,
            entitySpacing: Double,
            lineSpacing: Double,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.entities = entities
            self.alignment = alignment
            self.entitySpacing = entitySpacing
            self.lineSpacing = lineSpacing
        }
        
    }
    
}

extension UI.Layout.Composition.VFlow : IUICompositionLayoutEntity {
    
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
        let itemRange = Range(
            uncheckedBounds: (
                lower: bounds.x,
                upper: bounds.x + bounds.width
            )
        )
        var itemsSize: KindKit.Size = .zero
        var items: [Item] = []
        var line: Double = 0
        for entity in self.entities {
            let item = Item(
                entity: entity,
                size: entity.size(available: bounds.size)
            )
            if item.size.width > 0 {
                let newItems = items + [ item ]
                let newItemsSize = self._size(newItems)
                if newItemsSize.width >= bounds.width {
                    let layoutSize = self._layout(items, itemsSize, itemRange, bounds.y + line)
                    line += layoutSize.height + self.lineSpacing
                    itemsSize = item.size
                    items = [ item ]
                } else {
                    itemsSize = newItemsSize
                    items = newItems
                }
            }
        }
        if items.count > 0 {
            let layoutSize = self._layout(items, itemsSize, itemRange, bounds.y + line)
            line += layoutSize.height + self.lineSpacing
        }
        if line > 0 {
            line -= self.lineSpacing
        }
        return .init(
            width: bounds.width,
            height: line
        )
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        var itemsSize: KindKit.Size = .zero
        var items: [Item] = []
        var line: Double = 0
        for entity in self.entities {
            let item = Item(
                entity: entity,
                size: entity.size(available: available)
            )
            if item.size.width > 0 {
                let newItems = items + [ item ]
                let newItemsSize = self._size(newItems)
                if newItemsSize.width >= available.width {
                    line += itemsSize.height + self.lineSpacing
                    itemsSize = item.size
                    items = [ item ]
                } else {
                    itemsSize = newItemsSize
                    items = newItems
                }
            }
        }
        if items.count > 0 {
            line += itemsSize.height + self.lineSpacing
        }
        if line > 0 {
            line -= self.lineSpacing
        }
        return .init(
            width: available.width,
            height: line
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        var views: [IUIView] = []
        for entity in self.entities {
            views.append(contentsOf: entity.views(bounds: bounds))
        }
        return views
    }
    
}

private extension UI.Layout.Composition.VFlow {
    
    struct Item {
        
        let entity: IUICompositionLayoutEntity
        let size: Size
        
    }
    
}

private extension UI.Layout.Composition.VFlow {
    
    @inline(__always)
    func _layout(_ items: [Item], _ itemsSize: Size, _ bounds: Range< Double >, _ line: Double) -> Size {
        var size: Size = .zero
        switch self.alignment {
        case .left:
            var offset = bounds.lowerBound
            for item in items {
                guard item.size.width > 0 else { continue }
                let itemSize = item.entity.layout(
                    bounds: Rect(
                        topLeft: Point(
                            x: offset,
                            y: line
                        ),
                        size: item.size
                    )
                )
                size.width += itemSize.width + self.entitySpacing
                size.height = max(size.height, itemSize.height)
                offset += item.size.width + self.entitySpacing
            }
        case .center:
            var offset: Double = 0
            let center = bounds.lowerBound + ((bounds.upperBound - bounds.lowerBound) / 2)
            let itemsCenter = itemsSize.width / 2
            for item in items {
                guard item.size.width > 0 else { continue }
                let itemSize = item.entity.layout(
                    bounds: Rect(
                        topLeft: Point(
                            x: (center - itemsCenter) + offset,
                            y: line
                        ),
                        size: item.size
                    )
                )
                size.width += itemSize.width + self.entitySpacing
                size.height = max(size.height, itemSize.height)
                offset += item.size.width + self.entitySpacing
            }
        case .right:
            var offset = bounds.upperBound
            for item in items.reversed() {
                guard item.size.width > 0 else { continue }
                let itemSize = item.entity.layout(
                    bounds: Rect(
                        topRight: Point(
                            x: offset,
                            y: line
                        ),
                        size: item.size
                    )
                )
                size.width += itemSize.width + self.entitySpacing
                size.height = max(size.height, itemSize.height)
                offset -= item.size.width + self.entitySpacing
            }
        }
        if size.width > 0 {
            size.width -= self.entitySpacing
        }
        return size
    }
    
    @inline(__always)
    func _size(_ items: [Item]) -> Size {
        var size: Size = .zero
        for item in items {
            size.width += item.size.width + self.entitySpacing
            size.height = max(size.height, item.size.height)
        }
        if size.width > 0 {
            size.width -= self.entitySpacing
        }
        return size
    }

}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VFlow {
    
    @inlinable
    static func vFlow(
        alignment: UI.Layout.Composition.VFlow.Alignment = .center,
        entitySpacing: Double,
        lineSpacing: Double,
        entities: [IUICompositionLayoutEntity]
    ) -> Self {
        return .init(
            alignment: alignment,
            entitySpacing: entitySpacing,
            lineSpacing: lineSpacing,
            entities: entities
        )
    }
    
}
