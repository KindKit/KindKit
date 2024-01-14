//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class VFlowPart {
        
        public var alignment: Alignment
        public var itemSpacing: Double
        public var lineSpacing: Double
        public var items: [ILayoutPart]

        public init(
            alignment: Alignment = .center,
            itemSpacing: Double,
            lineSpacing: Double,
            items: [ILayoutPart]
        ) {
            self.items = items
            self.alignment = alignment
            self.itemSpacing = itemSpacing
            self.lineSpacing = lineSpacing
        }
        
    }
    
}

extension CompositionLayout.VFlowPart : ILayoutPart {
    
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
        let itemRange = Range(
            uncheckedBounds: (
                lower: bounds.x,
                upper: bounds.x + bounds.width
            )
        )
        var itemsSize: Size = .zero
        var items: [Item] = []
        var line: Double = 0
        for item in self.items {
            let item = Item(
                item: item,
                size: item.size(available: bounds.size)
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
    
    public func size(available: Size) -> Size {
        var itemsSize: Size = .zero
        var items: [Item] = []
        var line: Double = 0
        for item in self.items {
            let item = Item(
                item: item,
                size: item.size(available: available)
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
    
    public func views(bounds: Rect) -> [IView] {
        var views: [IView] = []
        for item in self.items {
            views.append(contentsOf: item.views(bounds: bounds))
        }
        return views
    }
    
}
private extension CompositionLayout.VFlowPart {
    
    @inline(__always)
    func _layout(_ items: [Item], _ itemsSize: Size, _ bounds: Range< Double >, _ line: Double) -> Size {
        var size = Size.zero
        switch self.alignment {
        case .left:
            var offset = bounds.lowerBound
            for item in items {
                guard item.size.width > 0 else { continue }
                let itemSize = item.item.layout(
                    bounds: Rect(
                        topLeft: Point(
                            x: offset,
                            y: line
                        ),
                        size: item.size
                    )
                )
                size.width += itemSize.width + self.itemSpacing
                size.height = max(size.height, itemSize.height)
                offset += item.size.width + self.itemSpacing
            }
        case .center:
            var offset: Double = 0
            let center = bounds.lowerBound + ((bounds.upperBound - bounds.lowerBound) / 2)
            let itemsCenter = itemsSize.width / 2
            for item in items {
                guard item.size.width > 0 else { continue }
                let itemSize = item.item.layout(
                    bounds: Rect(
                        topLeft: Point(
                            x: (center - itemsCenter) + offset,
                            y: line
                        ),
                        size: item.size
                    )
                )
                size.width += itemSize.width + self.itemSpacing
                size.height = max(size.height, itemSize.height)
                offset += item.size.width + self.itemSpacing
            }
        case .right:
            var offset = bounds.upperBound
            for item in items.reversed() {
                guard item.size.width > 0 else { continue }
                let itemSize = item.item.layout(
                    bounds: Rect(
                        topRight: Point(
                            x: offset,
                            y: line
                        ),
                        size: item.size
                    )
                )
                size.width += itemSize.width + self.itemSpacing
                size.height = max(size.height, itemSize.height)
                offset -= item.size.width + self.itemSpacing
            }
        }
        if size.width > 0 {
            size.width -= self.itemSpacing
        }
        return size
    }
    
    @inline(__always)
    func _size(_ items: [Item]) -> Size {
        var size = Size.zero
        for item in items {
            size.width += item.size.width + self.itemSpacing
            size.height = max(size.height, item.size.height)
        }
        if size.width > 0 {
            size.width -= self.itemSpacing
        }
        return size
    }

}
