//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct Space {
        
        public var mode: Mode
        public var space: Float
        
        public init(
            mode: Mode,
            space: Float
        ) {
            self.mode = mode
            self.space = space
        }
        
    }
    
}

public extension CompositionLayout.Space {
    
    enum Mode {
        case horizontal
        case vertical
    }
    
}

extension CompositionLayout.Space : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal: return SizeFloat(width: self.space, height: 0)
        case .vertical: return SizeFloat(width: 0, height: self.space)
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal: return SizeFloat(width: self.space, height: 0)
        case .vertical: return SizeFloat(width: 0, height: self.space)
        }
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return []
    }
    
}
