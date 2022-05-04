//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IInputListViewItem : AnyObject {
    
    var title: String { get }
    
}

public protocol IInputListView : IInputView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var items: [IInputListViewItem] { set get }
    
    var selectedItem: IInputListViewItem? { set get }
    
    var textFont: Font { set get }
    
    var textColor: Color { set get }
    
    var textInset: InsetFloat { set get }
    
    var placeholder: InputPlaceholder { set get }
    
    var placeholderInset: InsetFloat? { set get }
    
    var alignment: TextAlignment { set get }
    
    #if os(iOS)
    
    var toolbar: IInputToolbarView? { set get }
    
    #endif
    
    @discardableResult
    func items(_ value: [IInputListViewItem]) -> Self
    
    @discardableResult
    func selectedItem(_ value: IInputListViewItem?) -> Self
    
    @discardableResult
    func textFont(_ value: Font) -> Self
    
    @discardableResult
    func textColor(_ value: Color) -> Self
    
    @discardableResult
    func textInset(_ value: InsetFloat) -> Self
    
    @discardableResult
    func placeholder(_ value: InputPlaceholder) -> Self
    
    @discardableResult
    func placeholderInset(_ value: InsetFloat?) -> Self
    
    @discardableResult
    func alignment(_ value: TextAlignment) -> Self
    
    #if os(iOS)
    
    @discardableResult
    func toolbar(_ value: IInputToolbarView?) -> Self
    
    #endif
    
    @discardableResult
    func onBeginEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndEditing(_ value: (() -> Void)?) -> Self
    
}
