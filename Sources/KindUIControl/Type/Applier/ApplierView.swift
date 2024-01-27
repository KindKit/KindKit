//
//  KindKit
//

import KindUI
import KindMonadicMacro

@KindMonadic
public final class ApplierView<
    BodyType : IView,
    ApplierType : IApplier
> : IComposite, IView where ApplierType.TargetType == BodyType {
    
    public let body: BodyType
    
    public var content: ApplierType.InputType {
        didSet {
            self.applier.apply(self.content, self.body)
        }
    }
    
    @KindMonadicProperty
    public var applier: ApplierType {
        didSet {
            self.applier.apply(self.content, self.body)
        }
    }
    
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

extension ApplierView : IViewAlphable where BodyType : IViewAlphable {
}

extension ApplierView : IViewAnimatable where BodyType : IViewAnimatable {
}

extension ApplierView : IViewBorderable where BodyType : IViewBorderable {
}

extension ApplierView : IViewChangeable where BodyType : IViewChangeable {
}

extension ApplierView : IViewColorable where BodyType : IViewColorable {
}

extension ApplierView : IViewContentable where BodyType : IViewContentable {
}

extension ApplierView : IViewCornerRadiusable where BodyType : IViewCornerRadiusable {
}

extension ApplierView : IViewDragDestinationtable where BodyType : IViewDragDestinationtable {
}

extension ApplierView : IViewDragSourceable where BodyType : IViewDragSourceable {
}

extension ApplierView : IViewDynamicSizeable where BodyType : IViewDynamicSizeable {
}

extension ApplierView : IViewEditable where BodyType : IViewEditable {
}

extension ApplierView : IViewEnableable where BodyType : IViewEnableable {
}

extension ApplierView : IViewHighlightable where BodyType : IViewHighlightable {
}

extension ApplierView : IViewPageable where BodyType : IViewPageable {
}

extension ApplierView : IViewPressable where BodyType : IViewPressable {
}

extension ApplierView : IViewProgressable where BodyType : IViewProgressable {
}

extension ApplierView : IViewScrollable where BodyType : IViewScrollable {
}

extension ApplierView : IViewSelectable where BodyType : IViewSelectable {
}

extension ApplierView : IViewShadowable where BodyType : IViewShadowable {
}

extension ApplierView : IViewStaticSizeable where BodyType : IViewStaticSizeable {
}

extension ApplierView : IViewTextable where BodyType : IViewTextable {
}

extension ApplierView : IViewTintColorable where BodyType : IViewTintColorable {
}

extension ApplierView : IViewTransformable where BodyType : IViewTransformable {
}

extension ApplierView : IViewZoomable where BodyType : IViewZoomable {
}
