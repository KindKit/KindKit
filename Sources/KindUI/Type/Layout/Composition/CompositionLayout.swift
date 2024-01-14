//
//  KindKit
//

import KindMath

public final class CompositionLayout : ILayout {
    
    public weak var delegate: ILayoutDelegate?
    public weak var appearedView: IView?
    public var inset: Inset {
        didSet {
            guard self.inset != oldValue else { return }
            self.setNeedUpdate()
        }
    }
    public var content: ILayoutPart {
        didSet { self.setNeedUpdate() }
    }

    public init(
        inset: Inset = .zero,
        content: ILayoutPart
    ) {
        self.inset = inset
        self.content = content
    }
    
    public func invalidate() {
        self.content.invalidate()
    }
    
    public func invalidate(_ view: IView) {
        self.content.invalidate(view)
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        let size = self.content.layout(
            bounds: bounds.inset(self.inset)
        )
        if size.isZero == true {
            return .zero
        }
        return size.inset(-self.inset)
    }
    
    public func size(available: Size) -> Size {
        let size = self.content.size(
            available: available.inset(self.inset)
        )
        if size.isZero == true {
            return .zero
        }
        return size.inset(-self.inset)
    }
    
    public func views(bounds: Rect) -> [IView] {
        guard bounds.size.isZero == false else {
            return []
        }
        return self.content.views(bounds: bounds)
    }
    
}
