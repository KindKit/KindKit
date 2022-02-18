//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Fill {
        
        public var mode: Mode
        public var entity: ICompositionLayoutEntity
        
        public init(
            mode: Mode,
            entity: ICompositionLayoutEntity
        ) {
            self.mode = mode
            self.entity = entity
        }
        
    }
    
}

public extension CompositionLayout.Fill {
    
    enum Mode {
        case horizontal
        case vertical
        case both
    }
    
}

extension CompositionLayout.Fill : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        self.entity.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal:
            let size = self.entity.size(available: bounds.size)
            return self.entity.layout(
                bounds: RectFloat(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: size.height
                )
            )
        case .vertical:
            let size = self.entity.size(available: bounds.size)
            return self.entity.layout(
                bounds: RectFloat(
                    x: bounds.x,
                    y: bounds.y,
                    width: size.width,
                    height: bounds.height
                )
            )
        case .both:
            return self.entity.layout(bounds: bounds)
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal:
            let size = self.entity.size(available: available)
            return SizeFloat(
                width: available.width,
                height: size.height
            )
        case .vertical:
            let size = self.entity.size(available: available)
            return SizeFloat(
                width: size.width,
                height: available.height
            )
        case .both:
            return available
        }
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return self.entity.items(bounds: bounds)
    }
    
}
