//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct View {
        
        public let item: UI.Layout.Item
        
        public init(
            _ item: UI.Layout.Item
        ) {
            self.item = item
        }
        
        public init(
            _ view: IUIView
        ) {
            self.item = UI.Layout.Item(view)
        }
        
    }
    
}

extension UI.Layout.Composition.View : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(item: UI.Layout.Item) {
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        self.item.frame = bounds
        return bounds.size
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.item.size(available: available)
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return [ self.item ]
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.View {
    
    @inlinable
    static func view(
        _ item: UI.Layout.Item
    ) -> UI.Layout.Composition.View {
        return .init(item)
    }
    
    @inlinable
    static func view(
        _ view: IUIView
    ) -> UI.Layout.Composition.View {
        return .init(view)
    }
    
}
