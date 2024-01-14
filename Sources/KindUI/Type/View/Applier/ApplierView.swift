//
//  KindKit
//

import KindGraphics

public final class ApplierView<
    BodyType : IView,
    ApplierType : IApplier
> : IWidgetView where
    ApplierType.TargetType == BodyType
{
    
    public var content: ApplierType.InputType {
        didSet {
            self.applier.apply(self.content, self.body)
        }
    }
    public var applier: ApplierType {
        didSet {
            self.applier.apply(self.content, self.body)
        }
    }
    public let body: BodyType
    
    public init(
        content: ApplierType.InputType,
        applier: ApplierType,
        body: BodyType
    ) {
        self.content = content
        self.applier = applier
        self.body = body
        
        self.apply()
    }
    
}

public extension ApplierView {
    
    @inlinable
    func apply() {
        self.applier.apply(self.content, self.body)
    }
    
}

extension ApplierView : IViewReusable where BodyType : IViewReusable {
}

extension ApplierView : IViewDynamicSizeable where BodyType : IViewDynamicSizeable {
}

extension ApplierView : IViewStaticSizeable where BodyType : IViewStaticSizeable {
}

extension ApplierView : IViewTextable where BodyType : IViewTextable {
}

extension ApplierView : IViewTextAttributable where BodyType : IViewTextAttributable {
}

extension ApplierView : IViewTextPlainable where BodyType : IViewTextPlainable {
}

extension ApplierView : IViewEditable where BodyType : IViewEditable {
}

extension ApplierView : IViewStyleable where BodyType : IViewStyleable {
}

extension ApplierView : IViewHighlightable where BodyType : IViewHighlightable {
}

extension ApplierView : IViewSelectable where BodyType : IViewSelectable {
}

extension ApplierView : IViewLockable where BodyType : IViewLockable {
}

extension ApplierView : IViewPressable where BodyType : IViewPressable {
}

extension ApplierView : IViewAnimatable where BodyType : IViewAnimatable {
}

extension ApplierView : IViewCornerRadiusable where BodyType : IViewCornerRadiusable {
}

extension ApplierView : IViewColorable where BodyType : IViewColorable {
}

extension ApplierView : IViewAlphable where BodyType : IViewAlphable {
}
