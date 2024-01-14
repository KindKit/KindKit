//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class VSplitStackPart {
        
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

extension CompositionLayout.VSplitStackPart : ILayoutPart {
    
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
        case .left: self._layoutLeft(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .right: self._layoutRight(bounds: bounds, pass: pass)
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

private extension CompositionLayout.VSplitStackPart {
    
    @inline(__always)
    func _availableSize(available: Size, items: Int) -> Size {
        if items > 1 {
            return .init(
                width: available.width,
                height: (available.height - (self.spacing * Double(items - 1))) / Double(items)
            )
        } else if items > 0 {
            return .init(
                width: available.width,
                height: available.height / Double(items)
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
            if available.height.isInfinite == false {
                itemAvailableSize = self._availableSize(
                    available: available,
                    items: self.items.count
                )
                for (index, item) in self.items.enumerated() {
                    pass.sizes[index] = item.size(available: itemAvailableSize)
                }
                numberOfValid = pass.sizes.kk_count(where: { $0.height > 0 })
                if numberOfValid < self.items.count {
                    itemAvailableSize = self._availableSize(
                        available: available,
                        items: numberOfValid
                    )
                    for (index, item) in self.items.enumerated() {
                        guard pass.sizes[index].height > 0 else { continue }
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
                        width: available.width,
                        height: max($0.height, $1.height)
                    )
                })
                numberOfValid = pass.sizes.kk_count(where: { $0.height > 0 })
            }
            if numberOfValid > 1 {
                pass.bounding.height = (itemAvailableSize.height * Double(numberOfValid)) + (self.spacing * Double(numberOfValid - 1))
            } else if numberOfValid > 0 {
                pass.bounding.height = itemAvailableSize.height
            }
            for (index, size) in pass.sizes.enumerated() {
                guard size.height > 0 else { continue }
                pass.sizes[index] = .init(width: size.width, height: itemAvailableSize.height)
                pass.bounding.width = max(pass.bounding.width, size.width)
            }
        }
        return pass
    }
    
    @inline(__always)
    func _layoutLeft(bounds: Rect, pass: Pass) {
        var origin = bounds.left
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(left: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.center
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(center: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutRight(bounds: Rect, pass: Pass) {
        var origin = bounds.right
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(right: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, width: bounds.width, height: size.height))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
}
