//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VSpace {
        
        public var value: Double
        
        public init(
            _ value: Double
        ) {
            self.value = value
        }
        
    }
    
}

extension UI.Layout.Composition.VSpace : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return Size(width: 0, height: self.value)
    }
    
    public func size(available: Size) -> Size {
        return Size(width: 0, height: self.value)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VSpace {
    
    @inlinable
    static func vSpace(
        _ value: Double
    ) -> UI.Layout.Composition.VSpace {
        return .init(value)
    }
    
}
