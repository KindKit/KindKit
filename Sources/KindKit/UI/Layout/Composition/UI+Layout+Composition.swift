//
//  KindKit
//

import Foundation

public protocol IUICompositionLayoutEntity {
    
    func invalidate()
    
    func invalidate(_ view: IUIView)
    
    @discardableResult
    func layout(bounds: Rect) -> Size
    
    func size(available: Size) -> Size
    
    func views(bounds: Rect) -> [IUIView]
    
    
}

public extension UI.Layout {
    
    final class Composition : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var appearedView: IUIView?
        public var inset: Inset {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var entity: IUICompositionLayoutEntity {
            didSet { self.setNeedForceUpdate() }
        }

        public init(
            inset: Inset = .zero,
            entity: IUICompositionLayoutEntity
        ) {
            self.inset = inset
            self.entity = entity
        }
        
        public func invalidate() {
            self.entity.invalidate()
        }
        
        public func invalidate(_ view: IUIView) {
            self.entity.invalidate(view)
        }
        
        @discardableResult
        public func layout(bounds: Rect) -> KindKit.Size {
            let size = self.entity.layout(
                bounds: bounds.inset(self.inset)
            )
            if size.isZero == true {
                return .zero
            }
            return size.inset(-self.inset)
        }
        
        public func size(available: KindKit.Size) -> KindKit.Size {
            let size = self.entity.size(
                available: available.inset(self.inset)
            )
            if size.isZero == true {
                return .zero
            }
            return size.inset(-self.inset)
        }
        
        public func views(bounds: Rect) -> [IUIView] {
            guard bounds.size.isZero == false else {
                return []
            }
            return self.entity.views(bounds: bounds)
        }
        
    }
    
}

public extension IUILayout where Self == UI.Layout.Composition {
    
    static func composition(
        inset: Inset = .zero,
        entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition {
        return .init(
            inset: inset,
            entity: entity
        )
    }
    
}
