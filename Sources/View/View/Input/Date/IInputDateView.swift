//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum InputDateViewMode {
    case time
    case date
    case dateTime
}

public protocol IInputDateView : IInputView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var mode: InputDateViewMode { set get }
    
    var minimumDate: Date? { set get }
    
    var maximumDate: Date? { set get }
    
    var selectedDate: Date? { set get }
    
    var formatter: DateFormatter { set get }
    
    var locale: Locale { set get }
    
    var calendar: Calendar { set get }
    
    var timeZone: TimeZone? { set get }
    
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
    func mode(_ value: InputDateViewMode) -> Self
    
    @discardableResult
    func minimumDate(_ value: Date?) -> Self
    
    @discardableResult
    func maximumDate(_ value: Date?) -> Self
    
    @discardableResult
    func selectedDate(_ value: Date?) -> Self
    
    @discardableResult
    func formatter(_ value: DateFormatter) -> Self
    
    @discardableResult
    func locale(_ value: Locale) -> Self
    
    @discardableResult
    func calendar(_ value: Calendar) -> Self
    
    @discardableResult
    func timeZone(_ value: TimeZone?) -> Self
    
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
