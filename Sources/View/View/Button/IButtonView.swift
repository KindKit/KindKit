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
    case image
}

public enum ButtonViewImagePosition {
    case top
    case left
    case right
    case bottom
}

public protocol IButtonView : IView, IViewHighlightable, IViewLockable, IViewSelectable, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var inset: InsetFloat { set get }
    
    var width: DimensionBehaviour? { set get }
    
    var height: DimensionBehaviour? { set get }
    
    var alignment: ButtonViewAlignment { set get }
    
    var backgroundView: IView { set get }
    
    var spinnerPosition: ButtonViewSpinnerPosition { set get }
    
    var spinnerAnimating: Bool { set get }
    
    var spinnerView: ISpinnerView? { set get }
    
    var imagePosition: ButtonViewImagePosition { set get }
    
    var imageInset: InsetFloat { set get }
    
    var imageView: IView? { set get }
    
    var textInset: InsetFloat { set get }
    
    var textView: IView? { set get }
    
    @discardableResult
    func inset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func width(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func height(_ value: DimensionBehaviour?) -> Self
    
    @discardableResult
    func alignment(_ value: ButtonViewAlignment) -> Self
    
    @discardableResult
    func spinnerPosition(_ value: ButtonViewSpinnerPosition) -> Self
    
    @discardableResult
    func spinnerAnimating(_ value: Bool) -> Self
    
    @discardableResult
    func imagePosition(_ value: ButtonViewImagePosition) -> Self
    
    @discardableResult
    func imageInset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func textInset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func onPressed(_ value: (() -> Void)?) -> Self

}
