//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VirtualView {
        
        public var view: IUIView
        public var mode: Mode
        public var size: UI.Size.Dynamic
        
        public init(
            view: IUIView,
            mode: Mode,
            size: UI.Size.Dynamic
        ) {
            self.view = view
            self.mode = mode
            self.size = size
        }
        
    }
    
}

extension UI.Layout.Composition.VirtualView : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        let size: KindKit.Size
        switch self.mode {
        case .horizontal:
            size = self.view.size(available: .init(
                width: .infinity,
                height: bounds.height
            ))
        case .vertical:
            size = self.view.size(available: .init(
                width: bounds.width,
                height: .infinity
            ))
        }
        self.view.frame = Rect(
            topLeft: bounds.topLeft,
            size: size
        )
        return bounds.size
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        return self.size.apply(
            available: available,
            size: { available in
                return self.view.size(available: available)
            }
        )
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return [ self.view ]
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VirtualView {
    
    @inlinable
    static func virtual(
        view: IUIView,
        mode: UI.Layout.Composition.VirtualView.Mode,
        size: UI.Size.Dynamic
    ) -> Self {
        return .init(
            view: view,
            mode: mode,
            size: size
        )
    }
    
}
