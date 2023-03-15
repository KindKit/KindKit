//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class View {
        
        public var view: IUIView
        
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
    public func layout(bounds: Rect) -> KindKit.Size {
        self.view.frame = bounds
        return bounds.size
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
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
    ) -> Self {
        return .init(view)
    }
    
}
