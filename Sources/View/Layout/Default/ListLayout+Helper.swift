//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension ListLayout {
    
    struct Helper {
        
        static func layout(
            bounds: RectFloat,
            direction: Direction,
            alignment: Alignment = .fill,
            inset: InsetFloat,
            spacing: Float,
            minSpacing: Float? = nil,
            maxSpacing: Float? = nil,
            minSize: Float? = nil,
            maxSize: Float? = nil,
            operations: [Operation] = [],
            items: [LayoutItem],
            cache: inout [SizeFloat?]
        ) -> SizeFloat {
            switch direction {
            case .horizontal:
                guard items.count > 0 else { return SizeFloat(width: 0, height: bounds.height) }
                var size = self._passSize(
                    available: SizeFloat(width: .infinity, height: bounds.height - inset.vertical),
                    items: items,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.width
                )
                var pass = Pass(
                    inset: inset.horizontal,
                    spacings: items.count > 1 ? spacing * Float(items.count - 1) : 0,
                    items: size.full.width
                )
                var spacing = spacing
                if items.count > 1 {
                    pass = self._layoutPassSpacing(
                        pass: pass,
                        available: bounds.width,
                        inset: inset.horizontal,
                        spacing: &spacing,
                        itemsCount: items.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._layoutPassSize(
                    pass: pass,
                    available: bounds.width,
                    inset: inset.horizontal,
                    spacing: spacing,
                    itemsCount: items.count,
                    minSize: minSize,
                    maxSize: maxSize,
                    sizes: &size.sizes,
                    keyPath: \.width
                )
                switch alignment {
                case .leading: return self._hLeadingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                case .center: return self._hCenterLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                case .trailing: return self._hTrailingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                case .fill: return self._hFillLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                }
            case .vertical:
                guard items.count > 0 else { return SizeFloat(width: bounds.width, height: 0) }
                var size = self._passSize(
                    available: SizeFloat(width: bounds.width - inset.horizontal, height: .infinity),
                    items: items,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.height
                )
                var pass = Pass(
                    inset: inset.vertical,
                    spacings: items.count > 1 ? spacing * Float(items.count - 1) : 0,
                    items: size.full.height
                )
                var spacing = spacing
                if items.count > 1 {
                    pass = self._layoutPassSpacing(
                        pass: pass,
                        available: bounds.height,
                        inset: inset.vertical,
                        spacing: &spacing,
                        itemsCount: items.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._layoutPassSize(
                    pass: pass,
                    available: bounds.height,
                    inset: inset.vertical,
                    spacing: spacing,
                    itemsCount: items.count,
                    minSize: minSize,
                    maxSize: maxSize,
                    sizes: &size.sizes,
                    keyPath: \.height
                )
                switch alignment {
                case .leading: return self._vLeadingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                case .center: return self._vCenterLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                case .trailing: return self._vTrailingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                case .fill: return self._vFillLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, items: items, sizes: size.sizes)
                }
            }
        }
        
        static func size(
            available: SizeFloat,
            direction: Direction,
            alignment: Alignment = .fill,
            inset: InsetFloat,
            spacing: Float,
            minSpacing: Float? = nil,
            maxSpacing: Float? = nil,
            minSize: Float? = nil,
            maxSize: Float? = nil,
            items: [LayoutItem],
            operations: [Operation] = []
        ) -> SizeFloat {
            switch direction {
            case .horizontal:
                guard items.count > 0 else { return SizeFloat(width: available.width, height: 0) }
                var cache = Array< SizeFloat? >(repeating: nil, count: items.count)
                let size = self._passSize(
                    available: SizeFloat(width: .infinity, height: available.height - inset.vertical),
                    items: items,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.width
                )
                var pass = Pass(
                    inset: inset.horizontal,
                    spacings: items.count > 1 ? spacing * Float(items.count - 1) : 0,
                    items: size.full.width
                )
                if items.count > 1 {
                    pass = self._boundsPassSpacing(
                        pass: pass,
                        available: available.width,
                        inset: inset.horizontal,
                        itemsCount: items.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._boundsPassSize(
                    pass: pass,
                    available: available.width,
                    inset: inset.horizontal,
                    itemsCount: items.count,
                    minSize: minSize,
                    maxSize: maxSize
                )
                let height: Float
                switch alignment {
                case .leading, .center, .trailing:
                    height = size.max.height + inset.vertical
                case .fill:
                    if available.height.isInfinite == true {
                        height = size.max.height + inset.vertical
                    } else {
                        height = available.height
                    }
                }
                return SizeFloat(width: pass.full, height: height)
            case .vertical:
                guard items.count > 0 else { return SizeFloat(width: available.width, height: 0) }
                var cache = Array< SizeFloat? >(repeating: nil, count: items.count)
                let size = self._passSize(
                    available: SizeFloat(width: available.width - inset.horizontal, height: .infinity),
                    items: items,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.height
                )
                var pass = Pass(
                    inset: inset.vertical,
                    spacings: items.count > 1 ? spacing * Float(items.count - 1) : 0,
                    items: size.full.height
                )
                if items.count > 1 {
                    pass = self._boundsPassSpacing(
                        pass: pass,
                        available: available.height,
                        inset: inset.vertical,
                        itemsCount: items.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._boundsPassSize(
                    pass: pass,
                    available: available.height,
                    inset: inset.vertical,
                    itemsCount: items.count,
                    minSize: minSize,
                    maxSize: maxSize
                )
                let width: Float
                switch alignment {
                case .leading, .center, .trailing:
                    width = size.max.width + inset.horizontal
                case .fill:
                    if available.height.isInfinite == true {
                        width = size.max.width + inset.horizontal
                    } else {
                        width = available.width
                    }
                }
                return SizeFloat(width: width, height: pass.full)
            }
        }
        
    }
    
}

public extension ListLayout.Helper {
    
    enum OperationType {
        case insert
        case delete
    }
    
    class Operation {
        
        public var type: OperationType
        public var indices: [Int]
        public var progress: PercentFloat
        
        public init(
            type: OperationType,
            indices: [Int],
            progress: PercentFloat
        ) {
            self.type = type
            self.indices = indices
            self.progress = progress
        }

    }
    
}

extension ListLayout.Helper.Operation : Equatable {
    
    public static func == (lhs: ListLayout.Helper.Operation, rhs: ListLayout.Helper.Operation) -> Bool {
        return lhs.type == rhs.type && lhs.indices == rhs.indices
    }
    
}

private extension ListLayout.Helper {
    
    struct SizePass {
        
        var full: SizeFloat
        var max: SizeFloat
        var sizes: [SizeFloat]
        
    }
    
    struct Pass {
        
        var full: Float
        var spacings: Float
        var items: Float
        
        init(
            full: Float,
            spacings: Float,
            items: Float
        ) {
            self.full = full
            self.spacings = spacings
            self.items = items
        }

        init(
            inset: Float,
            spacings: Float,
            items: Float
        ) {
            self.full = (items + spacings) + inset
            self.spacings = spacings
            self.items = items
        }

    }
    
}

private extension ListLayout.Helper.Operation {
    
    @inline(__always)
    func _process(itemSize: SizeFloat, keyPath: WritableKeyPath< SizeFloat, Float >) -> SizeFloat {
        var result = itemSize
        switch self.type {
        case .insert: result[keyPath: keyPath] = result[keyPath: keyPath] * self.progress.value
        case .delete: result[keyPath: keyPath] = result[keyPath: keyPath] * self.progress.invert.value
        }
        return result
    }
    
}

private extension ListLayout.Helper {
    
    @inline(__always)
    static func _hLeadingLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(topLeft: origin, size: size)
            origin.x += size.width + spacing
        }
        return SizeFloat(
            width: pass.full,
            height: size.max.height + inset.vertical
        )
    }
    
    @inline(__always)
    static func _hCenterLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: bounds.x + inset.left,
            y: (bounds.y + (bounds.height / 2)) + inset.top
        )
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(left: origin, size: size)
            origin.x += size.width + spacing
        }
        return SizeFloat(
            width: pass.full,
            height: size.max.height + inset.vertical
        )
    }
    
    @inline(__always)
    static func _hTrailingLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: bounds.x + inset.left,
            y: (bounds.y + bounds.height) - inset.bottom
        )
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(bottomLeft: origin, size: size)
            origin.x += size.width + spacing
        }
        return SizeFloat(
            width: pass.full,
            height: size.max.height + inset.vertical
        )
    }
    
    @inline(__always)
    static func _hFillLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        let height: Float
        if bounds.height.isInfinite == true {
            height = size.max.height
        } else {
            height = bounds.height - inset.vertical
        }
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(x: origin.x, y: origin.y, width: size.width, height: height)
            origin.x += size.width + spacing
        }
        return SizeFloat(
            width: pass.full,
            height: bounds.height
        )
    }
    
}

private extension ListLayout.Helper {
    
    @inline(__always)
    static func _vLeadingLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(topLeft: origin, size: size)
            origin.y += size.height + spacing
        }
        return SizeFloat(
            width: size.max.width + inset.horizontal,
            height: pass.full
        )
    }
    
    @inline(__always)
    static func _vCenterLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: (bounds.x + (bounds.width / 2)) + inset.left,
            y: bounds.y + inset.top
        )
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(top: origin, size: size)
            origin.y += size.height + spacing
        }
        return SizeFloat(
            width: size.max.width + inset.horizontal,
            height: pass.full
        )
    }
    
    @inline(__always)
    static func _vTrailingLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: (bounds.x + bounds.width) - inset.right,
            y: bounds.y + inset.top
        )
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(topRight: origin, size: size)
            origin.y += size.height + spacing
        }
        return SizeFloat(
            width: size.max.width + inset.horizontal,
            height: pass.full
        )
    }
    
    @inline(__always)
    static func _vFillLayout(
        size: SizePass,
        pass: Pass,
        bounds: RectFloat,
        inset: InsetFloat,
        spacing: Float,
        items: [LayoutItem],
        sizes: [SizeFloat?]
    ) -> SizeFloat {
        var origin = PointFloat(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        let width: Float
        if bounds.width.isInfinite == true {
            width = size.max.width
        } else {
            width = bounds.width - inset.horizontal
        }
        for index in 0 ..< items.count {
            guard let size = sizes[index] else { continue }
            let item = items[index]
            item.frame = RectFloat(x: origin.x, y: origin.y, width: width, height: size.height)
            origin.y += size.height + spacing
        }
        return SizeFloat(
            width: bounds.width,
            height: pass.full
        )
    }
    
}

private extension ListLayout.Helper {
    
    @inline(__always)
    static func _layoutPassSpacing(
        pass: Pass,
        available: Float,
        inset: Float,
        spacing: inout Float,
        itemsCount: Int,
        minSpacing: Float?,
        maxSpacing: Float?
    ) -> Pass {
        let newFull: Float
        let newSpacings: Float
        if let maxSpacing = maxSpacing, pass.full < available {
            newSpacings = maxSpacing * Float(itemsCount - 1)
            newFull = (pass.items + pass.spacings) + inset
            if newFull > available {
                spacing = (newFull - pass.full) / Float(itemsCount - 1)
            } else {
                spacing = maxSpacing
            }
        } else if let minSpacing = minSpacing, pass.full > available {
            newSpacings = minSpacing * Float(itemsCount - 1)
            newFull = (pass.items + pass.spacings) + inset
            if newFull < available {
                spacing = (newFull - pass.full) / Float(itemsCount - 1)
            } else {
                spacing = minSpacing
            }
        } else {
            newFull = pass.full
            newSpacings = pass.spacings
        }
        return Pass(
            full: newFull,
            spacings: newSpacings,
            items: pass.items
        )
    }
    
    @inline(__always)
    static func _boundsPassSpacing(
        pass: Pass,
        available: Float,
        inset: Float,
        itemsCount: Int,
        minSpacing: Float?,
        maxSpacing: Float?
    ) -> Pass {
        let newFull: Float
        let newSpacings: Float
        if let maxSpacing = maxSpacing, pass.full < available {
            newSpacings = maxSpacing * Float(itemsCount - 1)
            newFull = min(available, (pass.items + newSpacings) + inset)
        } else if let minSpacing = minSpacing, pass.full > available {
            newSpacings = minSpacing * Float(itemsCount - 1)
            newFull = max(available, (pass.items + newSpacings) + inset)
        } else {
            newFull = pass.full
            newSpacings = pass.spacings
        }
        return Pass(
            full: newFull,
            spacings: newSpacings,
            items: pass.items
        )
    }
    
}

private extension ListLayout.Helper {
    
    @inline(__always)
    static func _layoutPassSize(
        pass: Pass,
        available: Float,
        inset: Float,
        spacing: Float,
        itemsCount: Int,
        minSize: Float?,
        maxSize: Float?,
        sizes: inout [SizeFloat],
        keyPath: WritableKeyPath< SizeFloat, Float >
    ) -> Pass {
        var newFull: Float
        var newItems: Float
        if let maxSize = maxSize, pass.full < available {
            let itemSize = min((available - inset - pass.spacings) / Float(itemsCount), maxSize)
            newItems = itemSize * Float(itemsCount)
            newFull = (newItems + pass.spacings) + inset
            for (index, value) in sizes.enumerated() {
                var size = value
                size[keyPath: keyPath] = itemSize
                sizes[index] = size
            }
        } else if let minSize = minSize, pass.full > available {
            let itemSize = max((available - inset - pass.spacings) / Float(itemsCount), minSize)
            newItems = itemSize * Float(itemsCount)
            newFull = (newItems + pass.spacings) + inset
            for (index, value) in sizes.enumerated() {
                var size = value
                size[keyPath: keyPath] = itemSize
                sizes[index] = size
            }
        } else {
            newFull = pass.full
            newItems = pass.items
        }
        return Pass(
            full: newFull,
            spacings: pass.spacings,
            items: newItems
        )
    }
    
    @inline(__always)
    static func _boundsPassSize(
        pass: Pass,
        available: Float,
        inset: Float,
        itemsCount: Int,
        minSize: Float?,
        maxSize: Float?
    ) -> Pass {
        var newFull: Float
        var newItems: Float
        if let maxSize = maxSize, pass.full < available {
            let itemSize = min((available - inset - pass.spacings) / Float(itemsCount), maxSize)
            newItems = itemSize * Float(itemsCount)
            newFull = (newItems + pass.spacings) + inset
        } else if let minSize = minSize, pass.full > available {
            let itemSize = max((available - inset - pass.spacings) / Float(itemsCount), minSize)
            newItems = itemSize * Float(itemsCount)
            newFull = (newItems + pass.spacings) + inset
        } else {
            newFull = pass.full
            newItems = pass.items
        }
        return Pass(
            full: newFull,
            spacings: pass.spacings,
            items: newItems
        )
    }
    
}

private extension ListLayout.Helper {
    
    @inline(__always)
    static func _passSize(
        available: SizeFloat,
        items: [LayoutItem],
        operations: [Operation],
        cache: inout [SizeFloat?],
        keyPath: WritableKeyPath< SizeFloat, Float >
    ) -> SizePass {
        var fillSize = SizeFloat.zero
        var maxSize = SizeFloat.zero
        var sizes = Array< SizeFloat >()
        for index in 0 ..< items.count {
            var itemSize: SizeFloat
            if let cacheSize = cache[index] {
                itemSize = cacheSize
            } else {
                itemSize = items[index].size(available: available)
                cache[index] = itemSize
            }
            if let operation = operations.first(where: { $0.indices.contains(index) }) {
                itemSize = operation._process(itemSize: itemSize, keyPath: keyPath)
            }
            fillSize.width += itemSize.width
            fillSize.height += itemSize.height
            maxSize.width = max(maxSize.width, itemSize.width)
            maxSize.height = max(maxSize.height, itemSize.height)
            sizes.append(itemSize)
        }
        return SizePass(
            full: fillSize,
            max: maxSize,
            sizes: sizes
        )
    }
    
}
