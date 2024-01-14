//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class VAccessoryPart {
        
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

extension CompositionLayout.VAccessoryPart : ILayoutPart {
    
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
    public func layout(bounds: Rect) -> Size {
        let sizes = self._size(available: bounds.size)
        let base = Rect(
            x: bounds.x,
            y: bounds.y,
            width: max(sizes.leadingSize.width, sizes.centerSize.width, sizes.trailingSize.width),
            height: bounds.height
        )
        if let leading = self.leading {
            leading.item.layout(bounds: Rect(
                topLeft: base.topLeft,
                width: base.width,
                height: sizes.leadingSize.height
            ))
        }
        if let trailing = self.trailing {
            trailing.item.layout(bounds: Rect(
                bottomLeft: base.bottomLeft,
                width: base.width,
                height: sizes.trailingSize.height
            ))
        }
        if self.filling == true {
            self.center.layout(bounds: Rect(
                x: base.x,
                y: base.y + (sizes.leadingSize.height + sizes.leadingSpacing),
                width: base.width,
                height: base.height - ((sizes.leadingSize.height + sizes.leadingSpacing) + (sizes.trailingSize.height + sizes.trailingSpacing))
            ))
        } else {
            self.center.layout(bounds: Rect(
                center: base.center,
                width: base.width,
                height: bounds.height - (max(sizes.leadingSize.height + sizes.leadingSpacing, sizes.trailingSize.height + sizes.trailingSpacing) * 2)
            ))
        }
        return base.size
    }
    
    public func size(available: Size) -> Size {
        let sizes = self._size(available: available)
        return .init(
            width: max(sizes.leadingSize.width, sizes.centerSize.width, sizes.trailingSize.width),
            height: sizes.leadingSize.height + sizes.leadingSpacing + sizes.centerSize.height + sizes.trailingSize.height + sizes.trailingSpacing
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

private extension CompositionLayout.VAccessoryPart {
    
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
                    width: max(leadingSize.width, available.width),
                    height: available.height - leadingSize.height
                ))
            } else {
                trailingSize = trailing.item.size(available: available)
                leadingSize = leading.item.size(available: .init(
                    width: max(trailingSize.width, available.width),
                    height: available.height - trailingSize.height
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
                width: max(leadingSize.width, available.width, trailingSize.width),
                height: available.height - ((leadingSize.height + leadingSpacing) + (trailingSize.height + trailingSpacing))
            ))
        } else {
            centerSize = self.center.size(available: .init(
                width: max(leadingSize.width, available.width, trailingSize.width),
                height: available.height - (max(leadingSize.height + leadingSpacing, trailingSize.height + trailingSpacing) * 2)
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
