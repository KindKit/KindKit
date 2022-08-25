//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IInputStringView : IInputView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var text: String { set get }
    
    var textFont: Font { set get }
    
    var textColor: Color { set get }
    
    var textInset: InsetFloat { set get }
    
    var editingColor: Color { set get }
    
    var placeholder: InputPlaceholder { set get }
    
    var placeholderInset: InsetFloat? { set get }
    
    var alignment: TextAlignment { set get }
    
    #if os(iOS)
    
    var toolbar: IInputToolbarView? { set get }
    
    var keyboard: InputKeyboard? { set get }
    
    #endif
    
    @discardableResult
    func onBeginEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onPressedReturn(_ value: (() -> Void)?) -> Self
    
}

public extension IInputStringView {
    
    @inlinable
    @discardableResult
    func text(_ value: String) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: Color) -> Self {
        self.textColor = value
        return self
    }
    
    @discardableResult
    func textInset(_ value: InsetFloat) -> Self {
        self.textInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func editingColor(_ value: Color) -> Self {
        self.editingColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: InputPlaceholder) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(_ value: InsetFloat?) -> Self {
        self.placeholderInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: TextAlignment) -> Self {
        self.alignment = value
        return self
    }
        
    #if os(iOS)
    
    @inlinable
    @discardableResult
    func toolbar(_ value: IInputToolbarView?) -> Self {
        self.toolbar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func keyboard(_ value: InputKeyboard?) -> Self {
        self.keyboard = value
        return self
    }
    
    #endif
    
}
