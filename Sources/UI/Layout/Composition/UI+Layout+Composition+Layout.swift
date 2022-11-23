//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Layout {
        
        public let layout: IUILayout
        
        public init(
            _ layout: IUILayout
        ) {
            self.layout = layout
        }
        
    }
    
}

extension UI.Layout.Composition.Layout : IUICompositionLayoutEntity {
    
    public func invalidate() {
        self.layout.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.layout.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return self.layout.layout(bounds: bounds)
    }
    
    public func size(available: Size) -> Size {
        return self.layout.size(available: available)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.layout.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Layout {
    
    @inlinable
    static func layout(
        _ layout: IUILayout
    ) -> UI.Layout.Composition.Layout {
        return .init(layout)
    }
    
}
