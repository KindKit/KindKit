//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Space {
        
        public var size: UI.Size.Static
        
        public init(
            width: UI.Size.Static.Dimension,
            height: UI.Size.Static.Dimension
        ) {
            self.size = .init(width, height)
        }
        
    }
    
}

extension UI.Layout.Composition.Space : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return self.size.apply(available: bounds.size)
    }
    
    public func size(available: Size) -> Size {
        return self.size.apply(available: available)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Space {
    
    @inlinable
    static func space(
        width: UI.Size.Static.Dimension,
        height: UI.Size.Static.Dimension
    ) -> UI.Layout.Composition.Space {
        return .init(
            width: width,
            height: height
        )
    }
    
}
