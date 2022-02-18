//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct VAccessory {
        
        public var leading: ICompositionLayoutEntity?
        public var center: ICompositionLayoutEntity
        public var trailing: ICompositionLayoutEntity?
        public var filling: Bool
        
        public init(
            leading: ICompositionLayoutEntity? = nil,
            center: ICompositionLayoutEntity,
            trailing: ICompositionLayoutEntity? = nil,
            filling: Bool
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
            self.filling = filling
        }
        
    }
    
}

extension CompositionLayout.VAccessory : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
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
        let centerSize = self.center.size(available: SizeFloat(
            width: max(leadingSize.width, bounds.width, trailingSize.width),
            height: bounds.height - (leadingSize.height + trailingSize.height)
        ))
        let base = RectFloat(
            x: bounds.x,
            y: bounds.y,
            width: max(leadingSize.width, centerSize.width, trailingSize.width),
            height: bounds.height
        )
        if let leading = self.leading {
            leading.layout(bounds: RectFloat(
                topLeft: base.topLeft,
                width: base.width,
                height: leadingSize.height
            ))
        }
        if let trailing = self.trailing {
            trailing.layout(bounds: RectFloat(
                bottomLeft: base.bottomLeft,
                width: base.width,
                height: trailingSize.height
            ))
        }
        if self.filling == true {
            self.center.layout(bounds: RectFloat(
                x: base.x,
                y: base.y + leadingSize.height,
                width: base.width,
                height: base.height - (leadingSize.height + trailingSize.height)
            ))
        } else {
            self.center.layout(bounds: RectFloat(
                center: base.center,
                width: base.width,
                height: bounds.height - (max(leadingSize.height, trailingSize.height) * 2)
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
        let centerSize = self.center.size(available: SizeFloat(
            width: max(leadingSize.width, available.width, trailingSize.width),
            height: available.height - (leadingSize.height + trailingSize.height)
        ))
        return SizeFloat(
            width: max(leadingSize.width, centerSize.width, trailingSize.width),
            height: available.height
        )
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        var items: [LayoutItem] = []
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
