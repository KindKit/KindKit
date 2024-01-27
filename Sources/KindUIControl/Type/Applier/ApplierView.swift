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
    @discardableResult
    func apply() -> Self {
        self.applier.apply(self.content, self.body)
        return self
    }
    
}

// MARK: Supporting standart features

extension ApplierView : IViewSupportAlpha where BodyType : IViewSupportAlpha {
}

extension ApplierView : IViewSupportAnimate where BodyType : IViewSupportAnimate {
}

extension ApplierView : IViewSupportBorder where BodyType : IViewSupportBorder {
}

extension ApplierView : IViewSupportChange where BodyType : IViewSupportChange {
}

extension ApplierView : IViewSupportColor where BodyType : IViewSupportColor {
}

extension ApplierView : IViewSupportContent where BodyType : IViewSupportContent {
}

extension ApplierView : IViewSupportCornerRadius where BodyType : IViewSupportCornerRadius {
}

extension ApplierView : IViewSupportDragDestination where BodyType : IViewSupportDragDestination {
}

extension ApplierView : IViewSupportDragSource where BodyType : IViewSupportDragSource {
}

extension ApplierView : IViewSupportDynamicSize where BodyType : IViewSupportDynamicSize {
}

extension ApplierView : IViewSupportEdit where BodyType : IViewSupportEdit {
}

extension ApplierView : IViewSupportEnable where BodyType : IViewSupportEnable {
}

extension ApplierView : IViewSupportHighlighted where BodyType : IViewSupportHighlighted {
}

extension ApplierView : IViewSupportPages where BodyType : IViewSupportPages {
}

extension ApplierView : IViewSupportPress where BodyType : IViewSupportPress {
}

extension ApplierView : IViewSupportProgress where BodyType : IViewSupportProgress {
}

extension ApplierView : IViewSupportScroll where BodyType : IViewSupportScroll {
}

extension ApplierView : IViewSupportSelected where BodyType : IViewSupportSelected {
}

extension ApplierView : IViewSupportShadow where BodyType : IViewSupportShadow {
}

extension ApplierView : IViewSupportStaticSize where BodyType : IViewSupportStaticSize {
}

extension ApplierView : IViewSupportText where BodyType : IViewSupportText {
}

extension ApplierView : IViewSupportTintColor where BodyType : IViewSupportTintColor {
}

extension ApplierView : IViewSupportTransform where BodyType : IViewSupportTransform {
}

extension ApplierView : IViewSupportZoom where BodyType : IViewSupportZoom {
}

// MARK: Supporting control features

extension ApplierView : IViewSupportBackground where BodyType : IViewSupportBackground {
}

extension ApplierView : IViewSupportIcon where BodyType : IViewSupportIcon {
}

extension ApplierView : IViewSupportInset where BodyType : IViewSupportInset {
}

extension ApplierView : IViewSupportItems where BodyType : IViewSupportItems {
}

extension ApplierView : IViewSupportPlacement where BodyType : IViewSupportPlacement {
}

extension ApplierView : IViewSupportSeparator where BodyType : IViewSupportSeparator {
}

extension ApplierView : IViewSupportTitle where BodyType : IViewSupportTitle {
}
