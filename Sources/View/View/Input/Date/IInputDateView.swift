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
    func onBeginEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEditing(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndEditing(_ value: (() -> Void)?) -> Self
    
}

public extension IInputDateView {
    
    @inlinable
    @discardableResult
    func mode(_ value: InputDateViewMode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minimumDate(_ value: Date?) -> Self {
        self.minimumDate = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maximumDate(_ value: Date?) -> Self {
        self.maximumDate = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedDate(_ value: Date?) -> Self {
        self.selectedDate = value
        return self
    }
    
    @inlinable
    @discardableResult
    func formatter(_ value: DateFormatter) -> Self {
        self.formatter = value
        return self
    }
    
    @inlinable
    @discardableResult
    func locale(_ value: Locale) -> Self {
        self.locale = value
        return self
    }
    
    @inlinable
    @discardableResult
    func calendar(_ value: Calendar) -> Self {
        self.calendar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func timeZone(_ value: TimeZone?) -> Self {
        self.timeZone = value
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
    
    @inlinable
    @discardableResult
    func textInset(_ value: InsetFloat) -> Self {
        self.textInset = value
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
    
    #endif
    
}
