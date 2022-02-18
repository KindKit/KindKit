//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Position {
        
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

public extension CompositionLayout.Position {
    
    enum Mode {
        case topLeft
        case top
        case topRight
        case left
        case center
        case right
        case bottomLeft
        case bottom
        case bottomRight
    }
    
}

extension CompositionLayout.Position : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        self.entity.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let size = self.entity.size(available: bounds.size)
        switch self.mode {
        case .topLeft: return self.entity.layout(bounds: RectFloat(topLeft: bounds.topLeft, size: size))
        case .top: return self.entity.layout(bounds: RectFloat(top: bounds.top, size: size))
        case .topRight: return self.entity.layout(bounds: RectFloat(topRight: bounds.topRight, size: size))
        case .left: return self.entity.layout(bounds: RectFloat(left: bounds.left, size: size))
        case .center: return self.entity.layout(bounds: RectFloat(center: bounds.center, size: size))
        case .right: return self.entity.layout(bounds: RectFloat(right: bounds.right, size: size))
        case .bottomLeft: return self.entity.layout(bounds: RectFloat(bottomLeft: bounds.bottomLeft, size: size))
        case .bottom: return self.entity.layout(bounds: RectFloat(bottom: bounds.bottom, size: size))
        case .bottomRight: return self.entity.layout(bounds: RectFloat(bottomRight: bounds.bottomRight, size: size))
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.entity.size(available: available)
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return self.entity.items(bounds: bounds)
    }
    
}
