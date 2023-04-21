//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VGrid {
        
        public var columns: [Column]
        public var spacing: Point
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            columns: [Column],
            spacing: Point = .zero,
            entities: [IUICompositionLayoutEntity]
        ) {
            if columns.isEmpty == true {
                self.columns = [ .proportionately ]
            } else {
                self.columns = columns
            }
            self.spacing = spacing
            self.entities = entities
        }
        
        public init(
            columns: Int,
            spacing: Point = .zero,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.columns = .init(repeating: .proportionately, count: max(1, columns))
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

extension UI.Layout.Composition.VGrid : IUICompositionLayoutEntity {
    
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
        let pass = self._pass(available: .init(
            width: bounds.width,
            height: .infinity
        ))
        self._layout(bounds: bounds, pass: pass)
        return .init(
            width: bounds.width,
            height: pass.bounding.height
        )
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        let pass = self._pass(available: .init(
            width: available.width,
            height: .infinity
        ))
        return .init(
            width: available.width,
            height: pass.bounding.height
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

private extension UI.Layout.Composition.VGrid {
    
    @inline(__always)
    func _pass(available: KindKit.Size) -> Pass {
        let widths: [Double]
        if self.columns.count < 2 {
            widths = .init(
                repeating: available.width,
                count: self.columns.count
            )
        } else {
            var fitColumns = 0
            var proportionatelyColumns = 0
            for column in self.columns {
                switch column {
                case .fit: fitColumns += 1
                case .proportionately: proportionatelyColumns += 1
                }
            }
            let spacing = self.spacing.x * Double(self.columns.count - 1)
            let width = (available.width - spacing) / Double(self.columns.count)
            if fitColumns > 0 {
                var accumulator: [Double] = .init(
                    repeating: 0,
                    count: self.columns.count
                )
                for index in self.entities.indices {
                    let entity = self.entities[index]
                    let columnIndex = index % self.columns.count
                    let column = self.columns[columnIndex]
                    switch column {
                    case .fit:
                        let size = entity.size(available: .init(
                            width: width,
                            height: available.height
                        ))
                        accumulator[columnIndex] = max(accumulator[columnIndex], size.width)
                    case .proportionately:
                        break
                    }
                }
                let fitSpacing = self.spacing.x * Double(fitColumns)
                let fitWidth = accumulator.reduce(0, { $0 + $1 })
                let leftWidth = available.width - (fitWidth + fitSpacing)
                let proportionatelySpacing = self.spacing.x * Double(proportionatelyColumns - 1)
                let proportionatelyWidth = (leftWidth - proportionatelySpacing) / Double(proportionatelyColumns)
                widths = self.columns.map({
                    switch $0 {
                    case .fit: return fitWidth
                    case .proportionately: return proportionatelyWidth
                    }
                })
            } else {
                widths = .init(
                    repeating: width,
                    count: self.columns.count
                )
            }
        }
        var pass = Pass(rows: [], bounding: .zero)
        var row = PassRow(items: [], size: 0)
        for index in self.entities.indices {
            let entity = self.entities[index]
            let column = index % self.columns.count
            let size = entity.size(available: .init(
                width: widths[column],
                height: available.height
            ))
            if size.height > 0 {
                let item = PassItem(entity: entity, size: size)
                row.items.append(item)
                row.size = max(row.size, size.height)
            }
            if row.items.count >= self.columns.count {
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
    func _layout(bounds: Rect, pass: Pass) {
        var originY = bounds.y
        for row in pass.rows {
            var originX = bounds.x
            for item in row.items {
                item.entity.layout(bounds: Rect(
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
        columns: [UI.Layout.Composition.VGrid.Column],
        spacing: Point = .zero,
        entities: [IUICompositionLayoutEntity]
    ) -> Self {
        return .init(
            columns: columns,
            spacing: spacing,
            entities: entities
        )
    }
    
    @inlinable
    static func vGrid(
        columns: Int,
        spacing: Point = .zero,
        entities: [IUICompositionLayoutEntity]
    ) -> Self {
        return .init(
            columns: columns,
            spacing: spacing,
            entities: entities
        )
    }
    
}
