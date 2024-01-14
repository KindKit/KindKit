//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class HSpacePart {
        
        public var value: Double
        
        public init(
            _ value: Double
        ) {
            self.value = value
        }
        
    }
    
}

extension CompositionLayout.HSpacePart : ILayoutPart {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return .init(width: self.value, height: 0)
    }
    
    public func size(available: Size) -> Size {
        return .init(width: self.value, height: 0)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return []
    }
    
}
