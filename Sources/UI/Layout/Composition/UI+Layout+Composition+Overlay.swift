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
    
    public func invalidate() {
        self.content.invalidate()
        self.overlay.invalidate()
    }
    
    public func invalidate(_ view: IUIView) {
        self.content.invalidate(view)
        self.overlay.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.overlay.layout(bounds: bounds)
        return size
    }
    
    public func size(available: Size) -> Size {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        let views = self.content.views(bounds: bounds)
        if views.isEmpty == true {
            return []
        }
        return views + self.overlay.views(bounds: bounds)
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
