//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class VGridPart {
        
        public var columns: [Column]
        public var spacing: Point
        public var items: [ILayoutPart]
        
        public init(
            columns: [Column],
            spacing: Point = .zero,
            items: [ILayoutPart]
        ) {
            if columns.isEmpty == true {
                self.columns = [ .proportionately ]
            } else {
                self.columns = columns
            }
            self.spacing = spacing
            self.items = items
        }
        
        public init(
            columns: Int,
            spacing: Point = .zero,
            items: [ILayoutPart]
        ) {
            self.columns = .init(repeating: .proportionately, count: max(1, columns))
            self.spacing = spacing
            self.items = items
        }
        
    }
    
}

extension CompositionLayout.VGridPart : ILayoutPart {
    
    public func invalidate() {
        for item in self.items {
            item.invalidate()
        }
    }
    
    public func invalidate(_ view: IView) {
        for item in self.items {
            item.invalidate(view)
        }
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
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
    
    public func size(available: Size) -> Size {
        let pass = self._pass(available: .init(
            width: available.width,
            height: .infinity
        ))
        return .init(
            width: available.width,
            height: pass.bounding.height
        )
    }
    
    public func views(bounds: Rect) -> [IView] {
        var views: [IView] = []
        for item in self.items {
            views.append(contentsOf: item.views(bounds: bounds))
        }
        return views
    }
    
}

private extension CompositionLayout.VGridPart {
    
    @inline(__always)
    func _pass(available: Size) -> Pass {
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
                for index in self.items.indices {
                    let item = self.items[index]
                    let columnIndex = index % self.columns.count
                    let column = self.columns[columnIndex]
                    switch column {
                    case .fit:
                        let size = item.size(available: .init(
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
                widths = .init(unsafeUninitializedCapacity: self.columns.count, initializingWith: { buffer, count in
                    for index in self.columns.indices {
                        let column = self.columns[index]
                        switch column {
                        case .fit: buffer[index] = accumulator[index]
                        case .proportionately: buffer[index] = proportionatelyWidth
                        }
                    }
                    count = self.columns.count
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
        for index in self.items.indices {
            let item = self.items[index]
            let column = index % self.columns.count
            let width = widths[column]
            let size = item.size(available: .init(
                width: width,
                height: available.height
            ))
            if size.height > 0 {
                let item = PassItem(
                    item: item,
                    size: .init(
                        width: width,
                        height: size.height
                    )
                )
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
                item.item.layout(bounds: Rect(
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
