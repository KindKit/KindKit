//
//  KindKit
//

import Foundation

public protocol IUICompositionLayoutEntity {
    
    func invalidate(item: UI.Layout.Item)
    
    @discardableResult
    func layout(bounds: RectFloat) -> SizeFloat
    
    func size(available: SizeFloat) -> SizeFloat
    
    func items(bounds: RectFloat) -> [UI.Layout.Item]
    
    
}

public extension UI.Layout {
    
    final class Composition : IUILayout {
        
        public unowned var delegate: IUILayoutDelegate?
        public unowned var view: IUIView?
        public var inset: InsetFloat {
            didSet(oldValue) {
                guard self.inset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var entity: IUICompositionLayoutEntity {
            didSet { self.setNeedForceUpdate() }
        }

        public init(
            inset: InsetFloat = .zero,
            entity: IUICompositionLayoutEntity
        ) {
            self.inset = inset
            self.entity = entity
        }
        
        public func invalidate(item: UI.Layout.Item) {
            self.entity.invalidate(item: item)
        }
        
        @discardableResult
        public func layout(bounds: RectFloat) -> SizeFloat {
            let size = self.entity.layout(
                bounds: bounds.inset(self.inset)
            )
            if size.isZero == true {
                return .zero
            }
            return size.inset(-self.inset)
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            let size = self.entity.size(
                available: available.inset(self.inset)
            )
            if size.isZero == true {
                return .zero
            }
            return size.inset(-self.inset)
        }
        
        public func items(bounds: RectFloat) -> [UI.Layout.Item] {
            return self.entity.items(bounds: bounds)
        }
        
    }
    
}

public extension IUILayout where Self == UI.Layout.Composition {
    
    static func composition(
        inset: InsetFloat = .zero,
        entity: IUICompositionLayoutEntity
    ) -> UI.Layout.Composition {
        return .init(
            inset: inset,
            entity: entity
        )
    }
    
}
