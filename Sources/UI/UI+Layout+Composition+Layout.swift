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
    
    public func invalidate(item: UI.Layout.Item) {
        self.layout.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        return self.layout.layout(bounds: bounds)
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.layout.size(available: available)
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return self.layout.items(bounds: bounds)
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
