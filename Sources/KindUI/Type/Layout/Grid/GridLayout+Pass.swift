//
//  KindKit
//

import KindMath

extension GridLayout {
    
    struct Pass {
        
        var available: Size
        var rows: [Row]
        var bounding: Size
        
    }
    
}

extension GridLayout {
    
    static func pass(
        available: Size,
        direction: Direction,
        columns: Int,
        spacing: Point,
        views: [IView]
    ) -> Pass {
        var cache: [Size?] = []
        return self.pass(
            available: available,
            direction: direction,
            columns: columns,
            spacing: spacing,
            views: views,
            cache: &cache
        )
    }
    
    static func pass(
        available: Size,
        direction: Direction,
        columns: Int,
        spacing: Point,
        views: [IView],
        cache: inout [Size?]
    ) -> Pass {
        switch direction {
        case .horizontal:
            let height: Double
            if columns > 1 {
                height = (available.height - (spacing.y * Double(columns - 1))) / Double(columns)
            } else {
                height = available.height
            }
            return Pass._hPass(
                available: available,
                height: height,
                columns: columns,
                spacing: spacing,
                views: views,
                cache: &cache
            )
        case .vertical:
            let width: Double
            if columns > 1 {
                width = (available.width - (spacing.x * Double(columns - 1))) / Double(columns)
            } else {
                width = available.width
            }
            return Pass._vPass(
                available: available,
                width: width,
                columns: columns,
                spacing: spacing,
                views: views,
                cache: &cache
            )
        }
    }
    
}

extension GridLayout.Pass {
    
    func layout(
        bounds: Rect,
        direction: GridLayout.Direction,
        alignment: GridLayout.Alignment,
        spacing: Point
    ) {
        switch direction {
        case .horizontal:
            switch alignment {
            case .fill: self._hFillLayout(bounds: bounds, spacing: spacing)
            case .leading: self._hLeadingLayout(bounds: bounds, spacing: spacing)
            case .center: self._hCenterLayout(bounds: bounds, spacing: spacing)
            case .trailing: self._hTrailingLayout(bounds: bounds, spacing: spacing)
            }
        case .vertical:
            switch alignment {
            case .fill: self._vFillLayout(bounds: bounds, spacing: spacing)
            case .leading: self._vLeadingLayout(bounds: bounds, spacing: spacing)
            case .center: self._vCenterLayout(bounds: bounds, spacing: spacing)
            case .trailing: self._vTrailingLayout(bounds: bounds, spacing: spacing)
            }
        }
    }
    
}

private extension GridLayout.Pass {
    
    static func _hPass(
        available: Size,
        height: Double,
        columns: Int,
        spacing: Point,
        views: [IView],
        cache: inout [Size?]
    ) -> GridLayout.Pass {
        var pass = GridLayout.Pass(available: available, rows: [], bounding: .zero)
        var row = Row(cells: [], origin: 0, size: 0)
        for (index, view) in views.enumerated() {
            let size: Size
            if let cacheSize = cache[index] {
                size = cacheSize
            } else {
                size = views[index].size(available: .init(
                    width: .infinity,
                    height: height
                ))
                cache[index] = size
            }
            if size.height > 0 {
                let view = Cell(view: view, available: height, size: size)
                row.cells.append(view)
                row.size = max(row.size, size.width)
            }
            if row.cells.count >= columns {
                pass.rows.append(row)
                pass.bounding.width += row.size + spacing.x
                row = Row(cells: [], origin: pass.bounding.width, size: 0)
            }
        }
        if row.cells.count > 0 {
            pass.bounding.width += row.size + spacing.x
            pass.rows.append(row)
        }
        if pass.bounding.width > 0 {
            pass.bounding.width -= spacing.x
            pass.bounding.height = available.height
        }
        return pass
    }
    
    static func _vPass(
        available: Size,
        width: Double,
        columns: Int,
        spacing: Point,
        views: [IView],
        cache: inout [Size?]
    ) -> GridLayout.Pass {
        var pass = GridLayout.Pass(available: available, rows: [], bounding: .zero)
        var row = Row(cells: [], origin: 0, size: 0)
        for (index, view) in views.enumerated() {
            let size: Size
            if let cacheSize = cache[index] {
                size = cacheSize
            } else {
                size = views[index].size(available: .init(
                    width: width,
                    height: .infinity
                ))
                cache[index] = size
            }
            if size.height > 0 {
                let view = Cell(view: view, available: width, size: size)
                row.cells.append(view)
                row.size = max(row.size, size.height)
            }
            if row.cells.count >= columns {
                pass.rows.append(row)
                pass.bounding.height += row.size + spacing.y
                row = Row(cells: [], origin: pass.bounding.height, size: 0)
            }
        }
        if row.cells.count > 0 {
            pass.bounding.height += row.size + spacing.y
            pass.rows.append(row)
        }
        if pass.bounding.height > 0 {
            pass.bounding.width = available.width
            pass.bounding.height -= spacing.y
        }
        return pass
    }
    
}

private extension GridLayout.Pass {
    
    func _hFillLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var x = bounds.x
        for row in self.rows {
            var y = bounds.y
            for cell in row.cells {
                cell.view.frame = .init(
                    x: x,
                    y: y,
                    width: row.size,
                    height: cell.available
                )
                y += cell.size.height + spacing.y
            }
            x += row.size + spacing.x
        }
    }
    
    func _hLeadingLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var x = bounds.x
        for row in self.rows {
            var y = bounds.y
            for cell in row.cells {
                cell.view.frame = .init(
                    top: .init(
                        x: x + (row.size / 2),
                        y: y
                    ),
                    size: cell.size
                )
                y += cell.size.height + spacing.y
            }
            x += row.size + spacing.x
        }
    }
    
    func _hCenterLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var x = bounds.x
        for row in self.rows {
            var y = bounds.y
            for cell in row.cells {
                cell.view.frame = .init(
                    center: .init(
                        x: x + (row.size / 2),
                        y: y + (cell.available / 2)
                    ),
                    size: cell.size
                )
                y += cell.size.height + spacing.y
            }
            x += row.size + spacing.x
        }
    }
    
    func _hTrailingLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var x = bounds.x
        for row in self.rows {
            var y = bounds.y
            for cell in row.cells {
                cell.view.frame = .init(
                    top: .init(
                        x: x + (row.size / 2),
                        y: y + cell.available
                    ),
                    size: cell.size
                )
                y += cell.size.height + spacing.y
            }
            x += row.size + spacing.x
        }
    }
    
}

private extension GridLayout.Pass {
    
    func _vFillLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var y = bounds.y
        for row in self.rows {
            var x = bounds.x
            for cell in row.cells {
                cell.view.frame = .init(
                    x: x,
                    y: y,
                    size: cell.size
                )
                x += cell.size.width + spacing.x
            }
            y += row.size + spacing.y
        }
    }
    
    func _vLeadingLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var y = bounds.y
        for row in self.rows {
            var x = bounds.x
            for cell in row.cells {
                cell.view.frame = .init(
                    top: .init(
                        x: x,
                        y: y + (row.size / 2)
                    ),
                    size: cell.size
                )
                x += cell.size.width + spacing.x
            }
            y += row.size + spacing.y
        }
    }
    
    func _vCenterLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var y = bounds.y
        for row in self.rows {
            var x = bounds.x
            for cell in row.cells {
                cell.view.frame = .init(
                    center: .init(
                        x: x + (cell.available / 2),
                        y: y + (row.size / 2)
                    ),
                    size: cell.size
                )
                x += cell.size.width + spacing.x
            }
            y += row.size + spacing.y
        }
    }
    
    func _vTrailingLayout(
        bounds: Rect,
        spacing: Point
    ) {
        var y = bounds.y
        for row in self.rows {
            var x = bounds.x
            for cell in row.cells {
                cell.view.frame = .init(
                    top: .init(
                        x: x + cell.available,
                        y: y + (row.size / 2)
                    ),
                    size: cell.size
                )
                x += cell.size.width + spacing.x
            }
            y += row.size + spacing.y
        }
    }
    
}
