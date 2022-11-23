//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct HAccessory {
        
        public var leading: IUICompositionLayoutEntity?
        public var leadingSpacing: Double
        public var center: IUICompositionLayoutEntity
        public var trailing: IUICompositionLayoutEntity?
        public var trailingSpacing: Double
        public var filling: Bool
        
        public init(
            leading: IUICompositionLayoutEntity? = nil,
            leadingSpacing: Double = 0,
            center: IUICompositionLayoutEntity,
            trailing: IUICompositionLayoutEntity? = nil,
            trailingSpacing: Double = 0,
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
    
    public func invalidate() {
        self.leading?.invalidate()
        self.center.invalidate()
        self.trailing?.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.leading?.invalidate(view)
        self.center.invalidate(view)
        self.trailing?.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let leadingSize: Size
        if let leading = self.leading {
            leadingSize = leading.size(available: bounds.size)
        } else {
            leadingSize = .zero
        }
        let trailingSize: Size
        if let trailing = self.trailing {
            trailingSize = trailing.size(available: bounds.size)
        } else {
            trailingSize = .zero
        }
        let accessorySize = (leadingSize.width + self.leadingSpacing) + (trailingSize.width + self.trailingSpacing)
        let centerSize = self.center.size(available: Size(
            width: bounds.width - accessorySize,
            height: max(leadingSize.height, bounds.height, trailingSize.height)
        ))
        let base = Rect(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: max(leadingSize.height, centerSize.height, trailingSize.height)
        )
        if let leading = self.leading {
            leading.layout(bounds: Rect(
                topLeft: base.topLeft,
                width: leadingSize.width,
                height: base.height
            ))
        }
        if let trailing = self.trailing {
            trailing.layout(bounds: Rect(
                topRight: base.topRight,
                width: trailingSize.width,
                height: base.height
            ))
        }
        if self.filling == true {
            self.center.layout(bounds: Rect(
                x: base.x + (leadingSize.width + self.leadingSpacing),
                y: base.y,
                width: base.width - accessorySize,
                height: base.height
            ))
        } else {
            self.center.layout(bounds: Rect(
                center: base.center,
                width: bounds.width - (max(leadingSize.width + self.leadingSpacing, trailingSize.width + self.trailingSpacing) * 2),
                height: base.height
            ))
        }
        return base.size
    }
    
    public func size(available: Size) -> Size {
        let leadingSize: Size
        if let leading = self.leading {
            leadingSize = leading.size(available: available)
        } else {
            leadingSize = .zero
        }
        let trailingSize: Size
        if let trailing = self.trailing {
            trailingSize = trailing.size(available: available)
        } else {
            trailingSize = .zero
        }
        let accessorySize = (leadingSize.width + self.leadingSpacing) + (trailingSize.width + self.trailingSpacing)
        let centerSize = self.center.size(available: Size(
            width: available.width - accessorySize,
            height: max(leadingSize.height, available.height, trailingSize.height)
        ))
        return Size(
            width: available.width,
            height: max(leadingSize.height, centerSize.height, trailingSize.height)
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        var views: [IUIView] = []
        if let leading = self.leading {
            views.append(contentsOf: leading.views(bounds: bounds))
        }
        if let trailing = self.trailing {
            views.append(contentsOf: trailing.views(bounds: bounds))
        }
        views.append(contentsOf: self.center.views(bounds: bounds))
        return views
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HAccessory {
    
    @inlinable
    static func hAccessory(
        leading: IUICompositionLayoutEntity? = nil,
        leadingSpacing: Double = 0,
        center: IUICompositionLayoutEntity,
        trailing: IUICompositionLayoutEntity? = nil,
        trailingSpacing: Double = 0,
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
