//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol ICompositionLayoutEntity {
    
    func invalidate(item: LayoutItem)
    
    @discardableResult
    func layout(bounds: RectFloat) -> SizeFloat
    
    func size(available: SizeFloat) -> SizeFloat
    
    func items(bounds: RectFloat) -> [LayoutItem]
    
    
}

public final class CompositionLayout : ILayout {
    
    public unowned var delegate: ILayoutDelegate?
    public unowned var view: IView?
    public var inset: InsetFloat {
        didSet(oldValue) {
            guard self.inset != oldValue else { return }
            self.setNeedForceUpdate()
        }
    }
    public var entity: ICompositionLayoutEntity {
        didSet { self.setNeedForceUpdate() }
    }

    public init(
        inset: InsetFloat = .zero,
        entity: ICompositionLayoutEntity
    ) {
        self.inset = inset
        self.entity = entity
    }
    
    public func invalidate(item: LayoutItem) {
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
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        return self.entity.items(bounds: bounds)
    }
    
}
