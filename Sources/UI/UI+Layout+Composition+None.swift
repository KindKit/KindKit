//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct None {
        
        public init() {
        }
        
    }
    
}

extension UI.Layout.Composition.None : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        return .zero
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return .zero
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.None {
    
    @inlinable
    static func none() -> UI.Layout.Composition.None {
        return .init()
    }
    
}
