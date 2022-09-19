//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Overlay {
        
        public var content: IUICompositionLayoutEntity
        public var overlay: IUICompositionLayoutEntity
        
        public init(
            content: IUICompositionLayoutEntity,
            overlay: IUICompositionLayoutEntity
        ) {
            self.content = content
            self.overlay = overlay
        }
        
    }
    
}

extension UI.Layout.Composition.Overlay : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
        self.content.invalidate(item: item)
        self.overlay.invalidate(item: item)
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.overlay.layout(bounds: bounds)
        return size
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        let items = self.content.items(bounds: bounds)
        if items.isEmpty == true {
            return []
        }
        return items + self.overlay.items(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Overlay {
    
    @inlinable
    static func overlay(
        content: IUICompositionLayoutEntity,
        overlay: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition.Overlay {
        return .init(
            content: content,
            overlay: overlay
        )
    }
    
}
