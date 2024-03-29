//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Overlay {
        
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
    public func layout(bounds: Rect) -> KindKit.Size {
        let size = self.content.layout(bounds: bounds)
        if size.isZero == true {
            return size
        }
        self.overlay.layout(bounds: .init(
            topLeft: bounds.topLeft,
            size: size
        ))
        return size
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        let size = self.content.size(available: available)
        if size.isZero == true {
            return size
        }
        return size
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return self.content.views(bounds: bounds) + self.overlay.views(bounds: bounds)
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Overlay {
    
    @inlinable
    static func overlay(
        content: IUICompositionLayoutEntity,
        overlay: IUICompositionLayoutEntity
    ) -> Self {
        return .init(content: content, overlay: overlay)
    }
    
}
