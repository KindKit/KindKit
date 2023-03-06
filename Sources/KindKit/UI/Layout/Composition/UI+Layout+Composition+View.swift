//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct View {
        
        public let view: IUIView
        
        public init(
            _ view: IUIView
        ) {
            self.view = view
        }
        
    }
    
}

extension UI.Layout.Composition.View : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        self.view.frame = bounds
        return bounds.size
    }
    
    public func size(available: Size) -> Size {
        return self.view.size(available: available)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return [ self.view ]
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.View {
    
    @inlinable
    static func view(
        _ view: IUIView
    ) -> UI.Layout.Composition.View {
        return .init(view)
    }
    
}
