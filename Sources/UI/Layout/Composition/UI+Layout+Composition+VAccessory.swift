//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct VAccessory {
        
        public var leading: IUICompositionLayoutEntity?
        public var leadingSpacing: Double
        public var center: IUICompositionLayoutEntity
        public var trailing: IUICompositionLayoutEntity?
        public var trailingSpacing: Double
        public var filling: Bool = true
        
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

extension UI.Layout.Composition.VAccessory : IUICompositionLayoutEntity {
    
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
        let accessorySize = (leadingSize.height + self.leadingSpacing) + (trailingSize.height + self.trailingSpacing)
        let centerSize = self.center.size(available: Size(
            width: max(leadingSize.width, bounds.width, trailingSize.width),
            height: bounds.height - accessorySize
        ))
        let base = Rect(
            x: bounds.x,
            y: bounds.y,
            width: max(leadingSize.width, centerSize.width, trailingSize.width),
            height: bounds.height
        )
        if let leading = self.leading {
            leading.layout(bounds: Rect(
                topLeft: base.topLeft,
                width: base.width,
                height: leadingSize.height
            ))
        }
        if let trailing = self.trailing {
            trailing.layout(bounds: Rect(
                bottomLeft: base.bottomLeft,
                width: base.width,
                height: trailingSize.height
            ))
        }
        if self.filling == true {
            self.center.layout(bounds: Rect(
                x: base.x,
                y: base.y + (leadingSize.height + self.leadingSpacing),
                width: base.width,
                height: base.height - accessorySize
            ))
        } else {
            self.center.layout(bounds: Rect(
                center: base.center,
                width: base.width,
                height: bounds.height - (max(leadingSize.height + self.leadingSpacing, trailingSize.height + self.trailingSpacing) * 2)
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
        let accessorySize = (leadingSize.height + self.leadingSpacing) + (trailingSize.height + self.trailingSpacing)
        let centerSize = self.center.size(available: Size(
            width: max(leadingSize.width, available.width, trailingSize.width),
            height: available.height - accessorySize
        ))
        return Size(
            width: max(leadingSize.width, centerSize.width, trailingSize.width),
            height: available.height
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

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VAccessory {
    
    @inlinable
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
