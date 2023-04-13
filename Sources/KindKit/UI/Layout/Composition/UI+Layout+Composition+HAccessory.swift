//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class HAccessory {
        
        public var leading: Info?
        public var center: IUICompositionLayoutEntity
        public var trailing: Info?
        public var filling: Bool
        
        public init(
            leading: Info? = nil,
            center: IUICompositionLayoutEntity,
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
            center: IUICompositionLayoutEntity,
            trailing: IUICompositionLayoutEntity,
            filling: Bool = true
        ) {
            self.init(
                leading: leading,
                center: center,
                trailing: .init(entity: trailing, spacing: 0),
                filling: filling
            )
        }
        
        public convenience init(
            leading: IUICompositionLayoutEntity,
            center: IUICompositionLayoutEntity,
            trailing: Info? = nil,
            filling: Bool = true
        ) {
            self.init(
                leading: .init(entity: leading, spacing: 0),
                center: center,
                trailing: trailing,
                filling: filling
            )
        }
        
        public convenience init(
            leading: IUICompositionLayoutEntity? = nil,
            center: IUICompositionLayoutEntity,
            trailing: IUICompositionLayoutEntity? = nil,
            filling: Bool = true
        ) {
            self.init(
                leading: leading.flatMap({ .init(entity: $0, spacing: 0) }),
                center: center,
                trailing: trailing.flatMap({ .init(entity: $0, spacing: 0) }),
                filling: filling
            )
        }
        
        @available(*, deprecated, renamed: "UI.Layout.Composition.HAccessory.init(leading:center:trailing:filling:)")
        public convenience init(
            leading: IUICompositionLayoutEntity? = nil,
            leadingSpacing: Double = 0,
            center: IUICompositionLayoutEntity,
            trailing: IUICompositionLayoutEntity? = nil,
            trailingSpacing: Double = 0,
            filling: Bool = true
        ) {
            self.init(
                leading: leading.flatMap({
                    return .init(
                        entity: $0,
                        spacing: leadingSpacing
                    )
                }),
                center: center,
                trailing: trailing.flatMap({
                    return .init(
                        entity: $0,
                        spacing: trailingSpacing
                    )
                }),
                filling: filling
            )
        }
        
    }
    
}

extension UI.Layout.Composition.HAccessory : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.leading?.entity.invalidate()
        self.center.invalidate()
        self.trailing?.entity.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.leading?.entity.invalidate(view)
        self.center.invalidate(view)
        self.trailing?.entity.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        let sizes = self._size(available: bounds.size)
        let base = Rect(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: max(sizes.leadingSize.height, sizes.centerSize.height, sizes.trailingSize.height)
        )
        if let leading = self.leading {
            leading.entity.layout(bounds: Rect(
                topLeft: base.topLeft,
                width: sizes.leadingSize.width,
                height: base.height
            ))
        }
        if let trailing = self.trailing {
            trailing.entity.layout(bounds: Rect(
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
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        let sizes = self._size(available: available)
        return .init(
            width: sizes.leadingSize.width + sizes.leadingSpacing + sizes.centerSize.width + sizes.trailingSize.width + sizes.trailingSpacing,
            height: max(sizes.leadingSize.height, sizes.centerSize.height, sizes.trailingSize.height)
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        var views: [IUIView] = []
        if let leading = self.leading {
            views.append(contentsOf: leading.entity.views(bounds: bounds))
        }
        if let trailing = self.trailing {
            views.append(contentsOf: trailing.entity.views(bounds: bounds))
        }
        views.append(contentsOf: self.center.views(bounds: bounds))
        return views
    }
    
}

private extension UI.Layout.Composition.HAccessory {
    
    func _size(available: KindKit.Size) -> (leadingSize: KindKit.Size, leadingSpacing: Double, centerSize: KindKit.Size, trailingSize: KindKit.Size, trailingSpacing: Double) {
        let leadingSize: KindKit.Size
        let leadingSpacing: Double
        let trailingSize: KindKit.Size
        let trailingSpacing: Double
        if let leading = self.leading, let trailing = self.trailing {
            leadingSpacing = leading.spacing
            trailingSpacing = trailing.spacing
            if leading.priority >= trailing.priority {
                leadingSize = leading.entity.size(available: available)
                trailingSize = trailing.entity.size(available: .init(
                    width: available.width - leadingSize.width,
                    height: max(leadingSize.height, available.height)
                ))
            } else {
                trailingSize = trailing.entity.size(available: available)
                leadingSize = leading.entity.size(available: .init(
                    width: available.width - trailingSize.width,
                    height: max(trailingSize.height, available.height)
                ))
            }
        } else if let leading = self.leading {
            leadingSize = leading.entity.size(available: available)
            leadingSpacing = leading.spacing
            trailingSize = .zero
            trailingSpacing = 0
        } else if let trailing = self.trailing {
            leadingSize = .zero
            leadingSpacing = 0
            trailingSize = trailing.entity.size(available: available)
            trailingSpacing = trailing.spacing
        } else {
            leadingSize = .zero
            leadingSpacing = 0
            trailingSize = .zero
            trailingSpacing = 0
        }
        let centerSize = self.center.size(available: .init(
            width: available.width - ((leadingSize.width + leadingSpacing) + (trailingSize.width + trailingSpacing)),
            height: max(leadingSize.height, available.height, trailingSize.height)
        ))
        return (
            leadingSize: leadingSize,
            leadingSpacing: leadingSpacing,
            centerSize: centerSize,
            trailingSize: trailingSize,
            trailingSpacing: trailingSpacing
        )
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HAccessory {
    
    @inlinable
    static func hAccessory(
        leading: UI.Layout.Composition.HAccessory.Info? = nil,
        center: IUICompositionLayoutEntity,
        trailing: UI.Layout.Composition.HAccessory.Info? = nil,
        filling: Bool = true
    ) -> Self {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    static func hAccessory(
        leading: UI.Layout.Composition.HAccessory.Info? = nil,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity,
        filling: Bool = true
    ) -> Self {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    static func hAccessory(
        leading: IUICompositionLayoutEntity,
        center: IUICompositionLayoutEntity,
        trailing: UI.Layout.Composition.HAccessory.Info? = nil,
        filling: Bool = true
    ) -> Self {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    static func hAccessory(
        leading: IUICompositionLayoutEntity? = nil,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity? = nil,
        filling: Bool = true
    ) -> Self {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    @available(*, deprecated, renamed: "hAccessory(leading:center:trailing:filling:)")
    static func hAccessory(
        leading: IUICompositionLayoutEntity? = nil,
        leadingSpacing: Double = 0,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity? = nil,
        trailingSpacing: Double = 0,
        filling: Bool = true
    ) -> Self {
        return .init(
            leading: leading,
            leadingSpacing: leadingSpacing,
            center: center,
            trailing: trailing,
            trailingSpacing: trailingSpacing,
            filling: filling
        )
    }
    
}
