//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct Space {
        
        public var mode: Mode
        public var space: Float
        
        public init(
            mode: Mode,
            space: Float
        ) {
            self.mode = mode
            self.space = space
        }
        
    }
    
}

extension UI.Layout.Composition.Space : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal: return Size(width: self.space, height: 0)
        case .vertical: return Size(width: 0, height: self.space)
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        switch self.mode {
        case .horizontal: return Size(width: self.space, height: 0)
        case .vertical: return Size(width: 0, height: self.space)
        }
    }
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        return []
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.Space {
    
    @inlinable
    static func space(
        mode: UI.Layout.Composition.Space.Mode,
        space: Float
    ) -> UI.Layout.Composition.Space {
        return .init(
            mode: mode,
            space: space
        )
    }
    
}
