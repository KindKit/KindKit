//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct HAccessory {
        
        public var leading: IUICompositionLayoutEntity?
        public var leadingSpacing: Float
        public var center: IUICompositionLayoutEntity
        public var trailing: IUICompositionLayoutEntity?
        public var trailingSpacing: Float
        public var filling: Bool
        
        public init(
            leading: IUICompositionLayoutEntity? = nil,
            leadingSpacing: Float = 0,
            center: IUICompositionLayoutEntity,
            trailing: IUICompositionLayoutEntity? = nil,
            trailingSpacing: Float = 0,
            filling: Bool = true
        ) {
            self.leading = leading
            self.leadingSpacing = leadingSpacing
            self.center = center
            self.trailing = trailing
            self.trailingSpacing = trailingSpacing
            self.filling = filling
        }
        
    }
    
}

extension UI.Layout.Composition.HAccessory : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
        self.leading?.invalidate(item: item)
        self.center.invalidate(item: item)
        self.trailing?.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let leadingSize: SizeFloat
        if let leading = self.leading {
            leadingSize = leading.size(available: bounds.size)
        } else {
            leadingSize = .zero
        }
        let trailingSize: SizeFloat
        if let trailing = self.trailing {
            trailingSize = trailing.size(available: bounds.size)
        } else {
            trailingSize = .zero
        }
        let accessorySize = (leadingSize.width + self.leadingSpacing) + (trailingSize.width + self.trailingSpacing)
        let centerSize = self.center.size(available: SizeFloat(
            width: bounds.width - accessorySize,
            height: max(leadingSize.height, bounds.height, trailingSize.height)
        ))
        let base = RectFloat(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: max(leadingSize.height, centerSize.height, trailingSize.height)
        )
        if let leading = self.leading {
            leading.layout(bounds: RectFloat(
                topLeft: base.topLeft,
                width: leadingSize.width,
                height: base.height
            ))
        }
        if let trailing = self.trailing {
            trailing.layout(bounds: RectFloat(
                topRight: base.topRight,
                width: trailingSize.width,
                height: base.height
            ))
        }
        if self.filling == true {
            self.center.layout(bounds: RectFloat(
                x: base.x + (leadingSize.width + self.leadingSpacing),
                y: base.y,
                width: base.width - accessorySize,
                height: base.height
            ))
        } else {
            self.center.layout(bounds: RectFloat(
                center: base.center,
                width: bounds.width - (max(leadingSize.width + self.leadingSpacing, trailingSize.width + self.trailingSpacing) * 2),
                height: base.height
            ))
        }
        return base.size
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let leadingSize: SizeFloat
        if let leading = self.leading {
            leadingSize = leading.size(available: available)
        } else {
            leadingSize = .zero
        }
        let trailingSize: SizeFloat
        if let trailing = self.trailing {
            trailingSize = trailing.size(available: available)
        } else {
            trailingSize = .zero
        }
        let accessorySize = (leadingSize.width + self.leadingSpacing) + (trailingSize.width + self.trailingSpacing)
        let centerSize = self.center.size(available: SizeFloat(
            width: available.width - accessorySize,
            height: max(leadingSize.height, available.height, trailingSize.height)
        ))
        return Size(
            width: available.width,
            height: max(leadingSize.height, centerSize.height, trailingSize.height)
        )
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        var items: [UI.Layout.Item] = []
        if let leading = self.leading {
            items.append(contentsOf: leading.items(bounds: bounds))
        }
        if let trailing = self.trailing {
            items.append(contentsOf: trailing.items(bounds: bounds))
        }
        items.append(contentsOf: self.center.items(bounds: bounds))
        return items
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HAccessory {
    
    @inlinable
    static func hAccessory(
        leading: IUICompositionLayoutEntity? = nil,
        leadingSpacing: Float = 0,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity? = nil,
        trailingSpacing: Float = 0,
        filling: Bool = true
    ) -> UI.Layout.Composition.HAccessory {
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
