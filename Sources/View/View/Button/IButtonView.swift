//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum ButtonViewAlignment {
    
    case fill
    case center
    
}

public enum ButtonViewSpinnerPosition {
    
    case fill
    case secondary
    
}

public enum ButtonViewSecondaryPosition {
    
    case top
    case left
    case right
    case bottom
    
}

public protocol IButtonView : IView, IViewDynamicSizeBehavioural, IViewHighlightable, IViewLockable, IViewSelectable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var inset: InsetFloat { set get }
    
    var alignment: ButtonViewAlignment { set get }
    
    var backgroundView: IView { set get }
    
    var spinnerPosition: ButtonViewSpinnerPosition { set get }
    
    var spinnerAnimating: Bool { set get }
    
    var spinnerView: ISpinnerView? { set get }
    
    var secondaryPosition: ButtonViewSecondaryPosition { set get }
    
    var secondaryInset: InsetFloat { set get }
    
    var secondaryView: IView? { set get }
    
    var primaryInset: InsetFloat { set get }
    
    var primaryView: IView { set get }
    
    @discardableResult
    func onPressed(_ value: (() -> Void)?) -> Self

}

public extension IButtonView {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: ButtonViewAlignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: ButtonViewSpinnerPosition) -> Self {
        self.spinnerPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerAnimating(_ value: Bool) -> Self {
        self.spinnerAnimating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: ButtonViewSecondaryPosition) -> Self {
        self.secondaryPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryInset(_ value: InsetFloat) -> Self {
        self.secondaryInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primaryInset(_ value: InsetFloat) -> Self {
        self.primaryInset = value
        return self
    }
    
}
