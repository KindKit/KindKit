//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct HAccessory {
        
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

extension CompositionLayout.HAccessory : ICompositionLayoutEntity {
    
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
            width: bounds.width - (leadingSize.width + trailingSize.width),
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
                x: base.x + leadingSize.width,
                y: base.y,
                width: base.width - (leadingSize.width + trailingSize.width),
                height: base.height
            ))
        } else {
            self.center.layout(bounds: RectFloat(
                center: base.center,
                width: bounds.width - (max(leadingSize.width, trailingSize.width) * 2),
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
        let centerSize = self.center.size(available: SizeFloat(
            width: available.width - (leadingSize.width + trailingSize.width),
            height: max(leadingSize.height, available.height, trailingSize.height)
        ))
        return SizeFloat(
            width: available.width,
            height: max(leadingSize.height, centerSize.height, trailingSize.height)
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
