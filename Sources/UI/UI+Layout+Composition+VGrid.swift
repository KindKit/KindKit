//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct VGrid {
        
        public var columns: Int
        public var spacing: PointFloat
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            columns: Int,
            spacing: PointFloat = .zero,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.columns = max(1, columns)
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

private extension UI.Layout.Composition.VGrid {
    
    struct Pass {
        
        var rows: [PassRow]
        var bounding: SizeFloat
        
    }
    
    struct PassRow {
        
        var items: [PassItem]
        var size: Float
        
    }
    
    struct PassItem {
        
        var entity: IUICompositionLayoutEntity
        var size: SizeFloat
        
    }
    
}

extension UI.Layout.Composition.VGrid : IUICompositionLayoutEntity {
    
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
        let pass = self._pass(available: SizeFloat(
            width: bounds.width,
            height: .infinity
        ))
        self._layout(bounds: bounds, pass: pass)
        return pass.bounding
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let pass = self._pass(available: SizeFloat(
            width: available.width,
            height: .infinity
        ))
        return pass.bounding
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        var items: [UI.Layout.Item] = []
        for entity in self.entities {
            items.append(contentsOf: entity.items(bounds: bounds))
        }
        return items
    }
    
}

private extension UI.Layout.Composition.VGrid {
    
    @inline(__always)
    func _width(available: SizeFloat) -> Float {
        if self.columns > 1 {
            return (available.width - (self.spacing.x * Float(self.columns - 1))) / Float(self.columns)
        }
        return available.width
    }
    
    @inline(__always)
    func _height(items: [PassItem]) -> Float {
        var height: Float = 0
        for item in items {
            height = max(height, item.size.height)
        }
        return height
    }
    
    @inline(__always)
    func _pass(available: SizeFloat) -> Pass {
        var pass = Pass(rows: [], bounding: .zero)
        var row = PassRow(items: [], size: 0)
        let width = self._width(available: available)
        for entity in self.entities {
            let size = entity.size(available: SizeFloat(
                width: width,
                height: available.height
            ))
            if size.height > 0 {
                let item = PassItem(entity: entity, size: size)
                row.items.append(item)
                row.size = max(row.size, size.height)
            }
            if row.items.count >= self.columns {
                pass.rows.append(row)
                pass.bounding.height += row.size + self.spacing.y
                row = PassRow(items: [], size: 0)
            }
        }
        if row.items.count > 0 {
            pass.bounding.height += row.size + self.spacing.y
            pass.rows.append(row)
        }
        if pass.bounding.height > 0 {
            pass.bounding.width = available.width
            pass.bounding.height -= self.spacing.y
        }
        return pass
    }
    
    @inline(__always)
    func _layout(bounds: RectFloat, pass: Pass) {
        var originY = bounds.y
        for row in pass.rows {
            var originX = bounds.x
            for item in row.items {
                item.entity.layout(bounds: RectFloat(
                    x: originX,
                    y: originY,
                    width: item.size.width,
                    height: item.size.height
                ))
                originX += item.size.width + self.spacing.x
            }
            originY += row.size + self.spacing.y
        }
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VGrid {
    
    @inlinable
    static func vGrid(
        columns: Int,
        spacing: PointFloat = .zero,
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.VGrid {
        return .init(
            columns: columns,
            spacing: spacing,
            entities: entities
        )
    }
    
}
