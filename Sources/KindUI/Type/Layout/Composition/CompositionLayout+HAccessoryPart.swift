//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class HAccessoryPart {
        
        public var leading: Info?
        public var center: ILayoutPart
        public var trailing: Info?
        public var filling: Bool
        
        public init(
            leading: Info? = nil,
            center: ILayoutPart,
            trailing: Info? = nil,
            filling: Bool = true
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
            self.filling = filling
        }
        
        public convenience init(
            leading: Info? = nil,
            center: ILayoutPart,
            trailing: ILayoutPart,
            filling: Bool = true
        ) {
            self.init(
                leading: leading,
                center: center,
                trailing: .init(item: trailing, spacing: 0),
                filling: filling
            )
        }
        
        public convenience init(
            leading: ILayoutPart,
            center: ILayoutPart,
            trailing: Info? = nil,
            filling: Bool = true
        ) {
            self.init(
                leading: .init(item: leading, spacing: 0),
                center: center,
                trailing: trailing,
                filling: filling
            )
        }
        
        public convenience init(
            leading: ILayoutPart? = nil,
            center: ILayoutPart,
            trailing: ILayoutPart? = nil,
            filling: Bool = true
        ) {
            self.init(
                leading: leading.flatMap({ .init(item: $0, spacing: 0) }),
                center: center,
                trailing: trailing.flatMap({ .init(item: $0, spacing: 0) }),
                filling: filling
            )
        }
        
    }
    
}

extension CompositionLayout.HAccessoryPart : ILayoutPart {
    
    public func invalidate() {
        self.leading?.item.invalidate()
        self.center.invalidate()
        self.trailing?.item.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.leading?.item.invalidate(view)
        self.center.invalidate(view)
        self.trailing?.item.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindMath.Size {
        let sizes = self._size(available: bounds.size)
        let base = Rect(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: max(sizes.leadingSize.height, sizes.centerSize.height, sizes.trailingSize.height)
        )
        if let leading = self.leading {
            leading.item.layout(bounds: Rect(
                topLeft: base.topLeft,
                width: sizes.leadingSize.width,
                height: base.height
            ))
        }
        if let trailing = self.trailing {
            trailing.item.layout(bounds: Rect(
                topRight: base.topRight,
                width: sizes.trailingSize.width,
                height: base.height
            ))
        }
        if self.filling == true {
            self.center.layout(bounds: Rect(
                x: base.x + (sizes.leadingSize.width + sizes.leadingSpacing),
                y: base.y,
                width: base.width - ((sizes.leadingSize.width + sizes.leadingSpacing) + (sizes.trailingSize.width + sizes.trailingSpacing)),
                height: base.height
            ))
        } else {
            self.center.layout(bounds: Rect(
                center: base.center,
                width: bounds.width - (max(sizes.leadingSize.width + sizes.leadingSpacing, sizes.trailingSize.width + sizes.trailingSpacing) * 2),
                height: base.height
            ))
        }
        return base.size
    }
    
    public func size(available: KindMath.Size) -> KindMath.Size {
        let sizes = self._size(available: available)
        return .init(
            width: sizes.leadingSize.width + sizes.leadingSpacing + sizes.centerSize.width + sizes.trailingSize.width + sizes.trailingSpacing,
            height: max(sizes.leadingSize.height, sizes.centerSize.height, sizes.trailingSize.height)
        )
    }
    
    public func views(bounds: Rect) -> [IView] {
        var views: [IView] = []
        if let leading = self.leading {
            views.append(contentsOf: leading.item.views(bounds: bounds))
        }
        if let trailing = self.trailing {
            views.append(contentsOf: trailing.item.views(bounds: bounds))
        }
        views.append(contentsOf: self.center.views(bounds: bounds))
        return views
    }
    
}

private extension CompositionLayout.HAccessoryPart {
    
    func _size(available: Size) -> (leadingSize: Size, leadingSpacing: Double, centerSize: Size, trailingSize: Size, trailingSpacing: Double) {
        let leadingSize: Size
        let leadingSpacing: Double
        let trailingSize: Size
        let trailingSpacing: Double
        if let leading = self.leading, let trailing = self.trailing {
            leadingSpacing = leading.spacing
            trailingSpacing = trailing.spacing
            if leading.priority >= trailing.priority {
                leadingSize = leading.item.size(available: available)
                trailingSize = trailing.item.size(available: .init(
                    width: available.width - leadingSize.width,
                    height: max(leadingSize.height, available.height)
                ))
            } else {
                trailingSize = trailing.item.size(available: available)
                leadingSize = leading.item.size(available: .init(
                    width: available.width - trailingSize.width,
                    height: max(trailingSize.height, available.height)
                ))
            }
        } else if let leading = self.leading {
            leadingSize = leading.item.size(available: available)
            leadingSpacing = leading.spacing
            trailingSize = .zero
            trailingSpacing = 0
        } else if let trailing = self.trailing {
            leadingSize = .zero
            leadingSpacing = 0
            trailingSize = trailing.item.size(available: available)
            trailingSpacing = trailing.spacing
        } else {
            leadingSize = .zero
            leadingSpacing = 0
            trailingSize = .zero
            trailingSpacing = 0
        }
        let centerSize: Size
        if self.filling == true {
            centerSize = self.center.size(available: .init(
                width: available.width - ((leadingSize.width + leadingSpacing) + (trailingSize.width + trailingSpacing)),
                height: max(leadingSize.height, available.height, trailingSize.height)
            ))
        } else {
            centerSize = self.center.size(available: .init(
                width: available.width - (max(leadingSize.width + leadingSpacing, trailingSize.width + trailingSpacing) * 2),
                height: max(leadingSize.height, available.height, trailingSize.height)
            ))
        }
        return (
            leadingSize: leadingSize,
            leadingSpacing: leadingSpacing,
            centerSize: centerSize,
            trailingSize: trailingSize,
            trailingSpacing: trailingSpacing
        )
    }
    
}
