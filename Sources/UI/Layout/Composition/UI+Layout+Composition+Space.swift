//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class Space {
        
        public var mode: Mode
        public var space: Double
        
        public init(
            mode: Mode,
            space: Double
        ) {
            self.mode = mode
            self.space = space
        }
        
    }
    
}

extension UI.Layout.Composition.Space : IUICompositionLayoutEntity {
    
    public func invalidate() {
    }
    
    public func invalidate(_ view: IUIView) {
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        switch self.mode {
        case .horizontal: return Size(width: self.space, height: 0)
        case .vertical: return Size(width: 0, height: self.space)
        }
    }
    
    public func size(available: Size) -> Size {
        switch self.mode {
        case .horizontal: return Size(width: self.space, height: 0)
        case .vertical: return Size(width: 0, height: self.space)
        }
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Space {
    
    @inlinable
    static func space(
        mode: UI.Layout.Composition.Space.Mode,
        space: Double
    ) -> UI.Layout.Composition.Space {
        return .init(
            mode: mode,
            space: space
        )
    }
    
}
