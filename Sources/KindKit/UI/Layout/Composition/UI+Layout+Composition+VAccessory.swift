//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VAccessory {
        
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
        
        @available(*, deprecated, renamed: "UI.Layout.Composition.VAccessory.init(leading:center:trailing:filling:)")
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

extension UI.Layout.Composition.VAccessory : IUICompositionLayoutEntity {
    
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
    public func layout(bounds: Rect) -> Size {
        let sizes = self._size(available: bounds.size)
        let base = Rect(
            x: bounds.x,
            y: bounds.y,
            width: max(sizes.leadingSize.width, sizes.centerSize.width, sizes.trailingSize.width),
            height: bounds.height
        )
        if let leading = self.leading {
            leading.entity.layout(bounds: Rect(
                topLeft: base.topLeft,
                width: base.width,
                height: sizes.leadingSize.height
            ))
        }
        if let trailing = self.trailing {
            trailing.entity.layout(bounds: Rect(
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
        return Size(
            width: max(sizes.leadingSize.width, sizes.centerSize.width, sizes.trailingSize.width),
            height: available.height
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

private extension UI.Layout.Composition.VAccessory {
    
    func _size(available: Size) -> (leadingSize: Size, leadingSpacing: Double, centerSize: Size, trailingSize: Size, trailingSpacing: Double) {
        let leadingSize: Size
        let leadingSpacing: Double
        let trailingSize: Size
        let trailingSpacing: Double
        if let leading = self.leading, let trailing = self.trailing {
            leadingSpacing = leading.spacing
            trailingSpacing = trailing.spacing
            if leading.priority >= trailing.priority {
                leadingSize = leading.entity.size(available: available)
                trailingSize = trailing.entity.size(available: Size(
                    width: max(leadingSize.width, available.width),
                    height: available.height - leadingSize.height
                ))
            } else {
                trailingSize = trailing.entity.size(available: available)
                leadingSize = leading.entity.size(available: Size(
                    width: max(trailingSize.width, available.width),
                    height: available.height - trailingSize.height
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
        let centerSize = self.center.size(available: Size(
            width: max(leadingSize.width, available.width, trailingSize.width),
            height: available.height - ((leadingSize.height + leadingSpacing) + (trailingSize.height + trailingSpacing))
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

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VAccessory {
    
    @inlinable
    static func vAccessory(
        leading: UI.Layout.Composition.VAccessory.Info? = nil,
        center: IUICompositionLayoutEntity,
        trailing: UI.Layout.Composition.VAccessory.Info? = nil,
        filling: Bool = true
    ) -> UI.Layout.Composition.VAccessory {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    static func vAccessory(
        leading: UI.Layout.Composition.VAccessory.Info? = nil,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity,
        filling: Bool = true
    ) -> UI.Layout.Composition.VAccessory {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    static func vAccessory(
        leading: IUICompositionLayoutEntity,
        center: IUICompositionLayoutEntity,
        trailing: UI.Layout.Composition.VAccessory.Info? = nil,
        filling: Bool = true
    ) -> UI.Layout.Composition.VAccessory {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    static func vAccessory(
        leading: IUICompositionLayoutEntity? = nil,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity? = nil,
        filling: Bool = true
    ) -> UI.Layout.Composition.VAccessory {
        return .init(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: filling
        )
    }
    
    @inlinable
    @available(*, deprecated, renamed: "vAccessory(leading:center:trailing:filling:)")
    static func vAccessory(
        leading: IUICompositionLayoutEntity? = nil,
        leadingSpacing: Double = 0,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity? = nil,
        trailingSpacing: Double = 0,
        filling: Bool = true
    ) -> UI.Layout.Composition.VAccessory {
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
