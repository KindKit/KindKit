//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class HSpace {
        
        public var value: Double
        
        public init(
            _ value: Double
        ) {
            self.value = value
        }
        
    }
    
}

extension UI.Layout.Composition.HSpace : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        return Size(width: self.value, height: 0)
    }
    
    public func size(available: Size) -> Size {
        return Size(width: self.value, height: 0)
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HSpace {
    
    @inlinable
    static func hSpace(
        _ value: Double
    ) -> UI.Layout.Composition.HSpace {
        return .init(value)
    }
    
}
