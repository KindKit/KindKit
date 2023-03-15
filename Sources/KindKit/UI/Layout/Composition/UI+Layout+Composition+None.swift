//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class None {
        
        public init() {
        }
        
    }
    
}

extension UI.Layout.Composition.None : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        return .zero
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        return .zero
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.None {
    
    @inlinable
    static func none() -> Self {
        return .init()
    }
    
}
