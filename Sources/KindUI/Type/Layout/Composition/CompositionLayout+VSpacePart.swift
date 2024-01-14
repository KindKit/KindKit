//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class VSpacePart {
        
        public var value: Double
        
        public init(
            _ value: Double
        ) {
            self.value = value
        }
        
    }
    
}

extension CompositionLayout.VSpacePart : ILayoutPart {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return .init(width: 0, height: self.value)
    }
    
    public func size(available: Size) -> Size {
        return .init(width: 0, height: self.value)
    }
    
    public func views(bounds: Rect) -> [IView] {
        return []
    }
    
}
