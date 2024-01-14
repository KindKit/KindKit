//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class HSplitStackPart {
        
        public var alignment: Alignment
        public var spacing: Double
        public var items: [ILayoutPart]
        
        public init(
            alignment: Alignment = .fill,
            spacing: Double = 0,
            items: [ILayoutPart]
        ) {
            self.alignment = alignment
            self.spacing = spacing
            self.items = items
        }
        
    }
    
}

extension CompositionLayout.HSplitStackPart : ILayoutPart {
    
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
        let pass = self._sizePass(available: bounds.size)
        switch self.alignment {
        case .top: self._layoutTop(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .bottom: self._layoutBottom(bounds: bounds, pass: pass)
        case .fill: self._layoutFill(bounds: bounds, pass: pass)
        }
        return pass.bounding
    }
    
    public func size(available: Size) -> Size {
        let pass = self._sizePass(available: available)
        return pass.bounding
    }
    
    public func views(bounds: Rect) -> [IView] {
        var views: [IView] = []
        for item in self.items {
            views.append(contentsOf: item.views(bounds: bounds))
        }
        return views
    }
    
}

private extension CompositionLayout.HSplitStackPart {
    
    @inline(__always)
    func _availableSize(available: Size, items: Int) -> Size {
        if items > 1 {
            return .init(
                width: (available.width - (self.spacing * Double(items - 1))) / Double(items),
                height: available.height
            )
        } else if items > 0 {
            return .init(
                width: available.width / Double(items),
                height: available.height
            )
        }
        return .zero
    }
    
    @inline(__always)
    func _sizePass(available: Size) -> Pass {
        var pass = Pass(
            sizes: Array(
                repeating: .zero,
                count: self.items.count
            ),
            bounding: .zero
        )
        if self.items.isEmpty == false {
            var itemAvailableSize: Size
            let numberOfValid: Int
            if available.width.isInfinite == false {
                itemAvailableSize = self._availableSize(
                    available: available,
                    items: self.items.count
                )
                for (index, item) in self.items.enumerated() {
                    pass.sizes[index] = item.size(available: itemAvailableSize)
                }
                numberOfValid = pass.sizes.kk_count(where: { $0.width > 0 })
                if numberOfValid < self.items.count {
                    itemAvailableSize = self._availableSize(
                        available: available,
                        items: numberOfValid
                    )
                    for (index, item) in self.items.enumerated() {
                        guard pass.sizes[index].width > 0 else { continue }
                        pass.sizes[index] = item.size(available: itemAvailableSize)
                    }
                }
            } else {
                for (index, item) in self.items.enumerated() {
                    pass.sizes[index] = item.size(available: available)
                }
                itemAvailableSize = pass.sizes.kk_reduce({
                    return .zero
                }, {
                    return $0
                }, {
                    return .init(
                        width: max($0.width, $1.width),
                        height: available.height
                    )
                })
                numberOfValid = pass.sizes.kk_count(where: { $0.width > 0 })
            }
            if numberOfValid > 1 {
                pass.bounding.width = (itemAvailableSize.width * Double(numberOfValid)) + (self.spacing * Double(numberOfValid - 1))
            } else if numberOfValid > 0 {
                pass.bounding.width = itemAvailableSize.width
            }
            for (index, size) in pass.sizes.enumerated() {
                guard size.width > 0 else { continue }
                pass.sizes[index] = .init(width: itemAvailableSize.width, height: size.height)
                pass.bounding.height = max(pass.bounding.height, size.height)
            }
        }
        return pass
    }
    
    @inline(__always)
    func _layoutTop(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.left
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(left: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutBottom(bounds: Rect, pass: Pass) {
        var origin = bounds.bottomLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(bottomLeft: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, width: size.width, height: bounds.height))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
}
