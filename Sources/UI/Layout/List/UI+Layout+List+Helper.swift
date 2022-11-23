//
//  KindKit
//

import Foundation

public extension UI.Layout.List {
    
    struct Helper {
        
        static func layout(
            bounds: Rect,
            direction: Direction,
            alignment: Alignment = .fill,
            inset: Inset,
            spacing: Double,
            minSpacing: Double? = nil,
            maxSpacing: Double? = nil,
            minSize: Double? = nil,
            maxSize: Double? = nil,
            operations: [Operation] = [],
            views: [IUIView],
            cache: inout [Size?]
        ) -> Size {
            switch direction {
            case .horizontal:
                guard views.count > 0 else { return Size(width: 0, height: bounds.height) }
                var size = self._passSize(
                    available: Size(width: .infinity, height: bounds.height - inset.vertical),
                    views: views,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.width
                )
                var pass = Pass(
                    inset: inset.horizontal,
                    spacings: views.count > 1 ? spacing * Double(views.count - 1) : 0,
                    views: size.full.width
                )
                var spacing = spacing
                if views.count > 1 {
                    pass = self._layoutPassSpacing(
                        pass: pass,
                        available: bounds.width,
                        inset: inset.horizontal,
                        spacing: &spacing,
                        viewsCount: views.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._layoutPassSize(
                    pass: pass,
                    available: bounds.width,
                    inset: inset.horizontal,
                    spacing: spacing,
                    viewsCount: views.count,
                    minSize: minSize,
                    maxSize: maxSize,
                    sizes: &size.sizes,
                    keyPath: \.width
                )
                switch alignment {
                case .leading: return self._hLeadingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                case .center: return self._hCenterLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                case .trailing: return self._hTrailingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                case .fill: return self._hFillLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                }
            case .vertical:
                guard views.count > 0 else { return Size(width: bounds.width, height: 0) }
                var size = self._passSize(
                    available: Size(width: bounds.width - inset.horizontal, height: .infinity),
                    views: views,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.height
                )
                var pass = Pass(
                    inset: inset.vertical,
                    spacings: views.count > 1 ? spacing * Double(views.count - 1) : 0,
                    views: size.full.height
                )
                var spacing = spacing
                if views.count > 1 {
                    pass = self._layoutPassSpacing(
                        pass: pass,
                        available: bounds.height,
                        inset: inset.vertical,
                        spacing: &spacing,
                        viewsCount: views.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._layoutPassSize(
                    pass: pass,
                    available: bounds.height,
                    inset: inset.vertical,
                    spacing: spacing,
                    viewsCount: views.count,
                    minSize: minSize,
                    maxSize: maxSize,
                    sizes: &size.sizes,
                    keyPath: \.height
                )
                switch alignment {
                case .leading: return self._vLeadingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                case .center: return self._vCenterLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                case .trailing: return self._vTrailingLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                case .fill: return self._vFillLayout(size: size, pass: pass, bounds: bounds, inset: inset, spacing: spacing, views: views, sizes: size.sizes)
                }
            }
        }
        
        static func size(
            available: Size,
            direction: Direction,
            alignment: Alignment = .fill,
            inset: Inset,
            spacing: Double,
            minSpacing: Double? = nil,
            maxSpacing: Double? = nil,
            minSize: Double? = nil,
            maxSize: Double? = nil,
            views: [IUIView],
            operations: [Operation] = []
        ) -> Size {
            switch direction {
            case .horizontal:
                guard views.count > 0 else { return Size(width: available.width, height: 0) }
                var cache = Array< Size? >(repeating: nil, count: views.count)
                let size = self._passSize(
                    available: Size(width: .infinity, height: available.height - inset.vertical),
                    views: views,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.width
                )
                var pass = Pass(
                    inset: inset.horizontal,
                    spacings: views.count > 1 ? spacing * Double(views.count - 1) : 0,
                    views: size.full.width
                )
                if views.count > 1 {
                    pass = self._boundsPassSpacing(
                        pass: pass,
                        available: available.width,
                        inset: inset.horizontal,
                        viewsCount: views.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._boundsPassSize(
                    pass: pass,
                    available: available.width,
                    inset: inset.horizontal,
                    viewsCount: views.count,
                    minSize: minSize,
                    maxSize: maxSize
                )
                let height: Double
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
                return Size(width: pass.full, height: height)
            case .vertical:
                guard views.count > 0 else { return Size(width: available.width, height: 0) }
                var cache = Array< Size? >(repeating: nil, count: views.count)
                let size = self._passSize(
                    available: Size(width: available.width - inset.horizontal, height: .infinity),
                    views: views,
                    operations: operations,
                    cache: &cache,
                    keyPath: \.height
                )
                var pass = Pass(
                    inset: inset.vertical,
                    spacings: views.count > 1 ? spacing * Double(views.count - 1) : 0,
                    views: size.full.height
                )
                if views.count > 1 {
                    pass = self._boundsPassSpacing(
                        pass: pass,
                        available: available.height,
                        inset: inset.vertical,
                        viewsCount: views.count,
                        minSpacing: minSpacing,
                        maxSpacing: maxSpacing
                    )
                }
                pass = self._boundsPassSize(
                    pass: pass,
                    available: available.height,
                    inset: inset.vertical,
                    viewsCount: views.count,
                    minSize: minSize,
                    maxSize: maxSize
                )
                let width: Double
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
                return Size(width: width, height: pass.full)
            }
        }
        
    }
    
}

public extension UI.Layout.List.Helper {
    
    enum OperationType {
        case insert
        case delete
    }
    
    final class Operation {
        
        public var type: OperationType
        public var indices: [Int]
        public var progress: Percent
        
        public init(
            type: OperationType,
            indices: [Int],
            progress: Percent
        ) {
            self.type = type
            self.indices = indices
            self.progress = progress
        }

    }
    
}

extension UI.Layout.List.Helper.Operation : Equatable {
    
    public static func == (lhs: UI.Layout.List.Helper.Operation, rhs: UI.Layout.List.Helper.Operation) -> Bool {
        return lhs.type == rhs.type && lhs.indices == rhs.indices
    }
    
}

private extension UI.Layout.List.Helper {
    
    struct SizePass {
        
        var full: Size
        var max: Size
        var sizes: [Size]
        
    }
    
    struct Pass {
        
        var full: Double
        var spacings: Double
        var views: Double
        
        init(
            full: Double,
            spacings: Double,
            views: Double
        ) {
            self.full = full
            self.spacings = spacings
            self.views = views
        }

        init(
            inset: Double,
            spacings: Double,
            views: Double
        ) {
            self.full = (views + spacings) + inset
            self.spacings = spacings
            self.views = views
        }

    }
    
}

private extension UI.Layout.List.Helper.Operation {
    
    @inline(__always)
    func _process(viewSize: Size, keyPath: WritableKeyPath< Size, Double >) -> Size {
        var result = viewSize
        switch self.type {
        case .insert: result[keyPath: keyPath] = result[keyPath: keyPath] * self.progress.value
        case .delete: result[keyPath: keyPath] = result[keyPath: keyPath] * self.progress.invert.value
        }
        return result
    }
    
}

private extension UI.Layout.List.Helper {
    
    @inline(__always)
    static func _hLeadingLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(topLeft: origin, size: size)
            origin.x += size.width + spacing
        }
        return Size(
            width: pass.full,
            height: size.max.height + inset.vertical
        )
    }
    
    @inline(__always)
    static func _hCenterLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: bounds.x + inset.left,
            y: (bounds.y + (bounds.height / 2)) + inset.top
        )
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(left: origin, size: size)
            origin.x += size.width + spacing
        }
        return Size(
            width: pass.full,
            height: size.max.height + inset.vertical
        )
    }
    
    @inline(__always)
    static func _hTrailingLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: bounds.x + inset.left,
            y: (bounds.y + bounds.height) - inset.bottom
        )
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(bottomLeft: origin, size: size)
            origin.x += size.width + spacing
        }
        return Size(
            width: pass.full,
            height: size.max.height + inset.vertical
        )
    }
    
    @inline(__always)
    static func _hFillLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        let height: Double
        if bounds.height.isInfinite == true {
            height = size.max.height
        } else {
            height = bounds.height - inset.vertical
        }
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(x: origin.x, y: origin.y, width: size.width, height: height)
            origin.x += size.width + spacing
        }
        return Size(
            width: pass.full,
            height: bounds.height
        )
    }
    
}

private extension UI.Layout.List.Helper {
    
    @inline(__always)
    static func _vLeadingLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(topLeft: origin, size: size)
            origin.y += size.height + spacing
        }
        return Size(
            width: size.max.width + inset.horizontal,
            height: pass.full
        )
    }
    
    @inline(__always)
    static func _vCenterLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: (bounds.x + (bounds.width / 2)) + inset.left,
            y: bounds.y + inset.top
        )
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(top: origin, size: size)
            origin.y += size.height + spacing
        }
        return Size(
            width: size.max.width + inset.horizontal,
            height: pass.full
        )
    }
    
    @inline(__always)
    static func _vTrailingLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: (bounds.x + bounds.width) - inset.right,
            y: bounds.y + inset.top
        )
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(topRight: origin, size: size)
            origin.y += size.height + spacing
        }
        return Size(
            width: size.max.width + inset.horizontal,
            height: pass.full
        )
    }
    
    @inline(__always)
    static func _vFillLayout(
        size: SizePass,
        pass: Pass,
        bounds: Rect,
        inset: Inset,
        spacing: Double,
        views: [IUIView],
        sizes: [Size?]
    ) -> Size {
        var origin = Point(
            x: bounds.x + inset.left,
            y: bounds.y + inset.top
        )
        let width: Double
        if bounds.width.isInfinite == true {
            width = size.max.width
        } else {
            width = bounds.width - inset.horizontal
        }
        for index in 0 ..< views.count {
            guard let size = sizes[index] else { continue }
            let view = views[index]
            view.frame = Rect(x: origin.x, y: origin.y, width: width, height: size.height)
            origin.y += size.height + spacing
        }
        return Size(
            width: bounds.width,
            height: pass.full
        )
    }
    
}

private extension UI.Layout.List.Helper {
    
    @inline(__always)
    static func _layoutPassSpacing(
        pass: Pass,
        available: Double,
        inset: Double,
        spacing: inout Double,
        viewsCount: Int,
        minSpacing: Double?,
        maxSpacing: Double?
    ) -> Pass {
        let newFull: Double
        let newSpacings: Double
        if let maxSpacing = maxSpacing, pass.full < available {
            newSpacings = maxSpacing * Double(viewsCount - 1)
            newFull = (pass.views + pass.spacings) + inset
            if newFull > available {
                spacing = (newFull - pass.full) / Double(viewsCount - 1)
            } else {
                spacing = maxSpacing
            }
        } else if let minSpacing = minSpacing, pass.full > available {
            newSpacings = minSpacing * Double(viewsCount - 1)
            newFull = (pass.views + pass.spacings) + inset
            if newFull < available {
                spacing = (newFull - pass.full) / Double(viewsCount - 1)
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
            views: pass.views
        )
    }
    
    @inline(__always)
    static func _boundsPassSpacing(
        pass: Pass,
        available: Double,
        inset: Double,
        viewsCount: Int,
        minSpacing: Double?,
        maxSpacing: Double?
    ) -> Pass {
        let newFull: Double
        let newSpacings: Double
        if let maxSpacing = maxSpacing, pass.full < available {
            newSpacings = maxSpacing * Double(viewsCount - 1)
            newFull = min(available, (pass.views + newSpacings) + inset)
        } else if let minSpacing = minSpacing, pass.full > available {
            newSpacings = minSpacing * Double(viewsCount - 1)
            newFull = max(available, (pass.views + newSpacings) + inset)
        } else {
            newFull = pass.full
            newSpacings = pass.spacings
        }
        return Pass(
            full: newFull,
            spacings: newSpacings,
            views: pass.views
        )
    }
    
}

private extension UI.Layout.List.Helper {
    
    @inline(__always)
    static func _layoutPassSize(
        pass: Pass,
        available: Double,
        inset: Double,
        spacing: Double,
        viewsCount: Int,
        minSize: Double?,
        maxSize: Double?,
        sizes: inout [Size],
        keyPath: WritableKeyPath< Size, Double >
    ) -> Pass {
        var newFull: Double
        var newItems: Double
        if let maxSize = maxSize, pass.full < available {
            let viewSize = min((available - inset - pass.spacings) / Double(viewsCount), maxSize)
            newItems = viewSize * Double(viewsCount)
            newFull = (newItems + pass.spacings) + inset
            for (index, value) in sizes.enumerated() {
                var size = value
                size[keyPath: keyPath] = viewSize
                sizes[index] = size
            }
        } else if let minSize = minSize, pass.full > available {
            let viewSize = max((available - inset - pass.spacings) / Double(viewsCount), minSize)
            newItems = viewSize * Double(viewsCount)
            newFull = (newItems + pass.spacings) + inset
            for (index, value) in sizes.enumerated() {
                var size = value
                size[keyPath: keyPath] = viewSize
                sizes[index] = size
            }
        } else {
            newFull = pass.full
            newItems = pass.views
        }
        return Pass(
            full: newFull,
            spacings: pass.spacings,
            views: newItems
        )
    }
    
    @inline(__always)
    static func _boundsPassSize(
        pass: Pass,
        available: Double,
        inset: Double,
        viewsCount: Int,
        minSize: Double?,
        maxSize: Double?
    ) -> Pass {
        var newFull: Double
        var newItems: Double
        if let maxSize = maxSize, pass.full < available {
            let viewSize = min((available - inset - pass.spacings) / Double(viewsCount), maxSize)
            newItems = viewSize * Double(viewsCount)
            newFull = (newItems + pass.spacings) + inset
        } else if let minSize = minSize, pass.full > available {
            let viewSize = max((available - inset - pass.spacings) / Double(viewsCount), minSize)
            newItems = viewSize * Double(viewsCount)
            newFull = (newItems + pass.spacings) + inset
        } else {
            newFull = pass.full
            newItems = pass.views
        }
        return Pass(
            full: newFull,
            spacings: pass.spacings,
            views: newItems
        )
    }
    
}

private extension UI.Layout.List.Helper {
    
    @inline(__always)
    static func _passSize(
        available: Size,
        views: [IUIView],
        operations: [Operation],
        cache: inout [Size?],
        keyPath: WritableKeyPath< Size, Double >
    ) -> SizePass {
        var fillSize = Size.zero
        var maxSize = Size.zero
        var sizes = Array< Size >()
        for index in 0 ..< views.count {
            var viewSize: Size
            if let cacheSize = cache[index] {
                viewSize = cacheSize
            } else {
                viewSize = views[index].size(available: available)
                cache[index] = viewSize
            }
            if let operation = operations.first(where: { $0.indices.contains(index) }) {
                viewSize = operation._process(viewSize: viewSize, keyPath: keyPath)
            }
            fillSize.width += viewSize.width
            fillSize.height += viewSize.height
            maxSize.width = max(maxSize.width, viewSize.width)
            maxSize.height = max(maxSize.height, viewSize.height)
            sizes.append(viewSize)
        }
        return SizePass(
            full: fillSize,
            max: maxSize,
            sizes: sizes
        )
    }
    
}
