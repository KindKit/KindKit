//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

protocol InputDateViewDelegate : AnyObject {
    
    func beginEditing()
    func select(date: Date)
    func endEditing()
    
}

public class InputDateView : IInputDateView {
    
    public private(set) unowned var layout: ILayout?
    public unowned var item: LayoutItem?
    public var native: NativeView {
        return self._view
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return RectFloat(self._view.bounds)
    }
    public private(set) var isVisible: Bool
    public var isHidden: Bool {
        didSet(oldValue) {
            guard self.isHidden != oldValue else { return }
            self.setNeedForceLayout()
        }
    }
    public var isEditing: Bool {
        guard self.isLoaded == true else { return false }
        return self._view.isFirstResponder
    }
    public var width: DimensionBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: DimensionBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var mode: InputDateViewMode {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(mode: self.mode)
        }
    }
    public var minimumDate: Date? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(minimumDate: self.minimumDate)
        }
    }
    public var maximumDate: Date? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(maximumDate: self.maximumDate)
        }
    }
    public var selectedDate: Date? {
        set(value) {
            self._selectedDate = value
            guard self.isLoaded == true else { return }
            self._view.update(selectedDate: self._selectedDate)
        }
        get { return self._selectedDate }
    }
    public var formatter: DateFormatter {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(formatter: self.formatter)
        }
    }
    public var locale: Locale {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(locale: self.locale)
        }
    }
    public var calendar: Calendar {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(calendar: self.calendar)
        }
    }
    public var timeZone: TimeZone? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(timeZone: self.timeZone)
        }
    }
    public var textFont: Font {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(textFont: self.textFont)
        }
    }
    public var textColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(textColor: self.textColor)
        }
    }
    public var textInset: InsetFloat {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(textInset: self.textInset)
        }
    }
    public var placeholder: InputPlaceholder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(placeholder: self.placeholder)
        }
    }
    public var placeholderInset: InsetFloat? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(placeholderInset: self.placeholderInset)
        }
    }
    public var alignment: TextAlignment {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(alignment: self.alignment)
        }
    }
    #if os(iOS)
    public var toolbar: IInputToolbarView? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(toolbar: self.toolbar)
        }
    }
    #endif
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
        }
    }
    public var alpha: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _selectedDate: Date?
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onBeginEditing: (() -> Void)?
    private var _onEditing: (() -> Void)?
    private var _onEndEditing: (() -> Void)?
    
    public init(
        reuseBehaviour: ReuseItemBehaviour = .unloadWhenDisappear,
        reuseName: String? = nil,
        width: DimensionBehaviour,
        height: DimensionBehaviour,
        mode: InputDateViewMode,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
        selectedDate: Date? = nil,
        formatter: DateFormatter,
        locale: Locale = Locale.current,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone? = nil,
        textFont: Font,
        textColor: Color,
        textInset: InsetFloat = InsetFloat(horizontal: 8, vertical: 4),
        placeholder: InputPlaceholder,
        placeholderInset: InsetFloat? = nil,
        alignment: TextAlignment = .left,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.mode = mode
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self._selectedDate = selectedDate
        self.formatter = formatter
        self.locale = locale
        self.calendar = calendar
        self.timeZone = timeZone
        self.textFont = textFont
        self.textColor = textColor
        self.textInset = textInset
        self.placeholder = placeholder
        self.placeholderInset = placeholderInset
        self.alignment = alignment
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem(behaviour: reuseBehaviour, name: reuseName)
        self._reuse.configure(owner: self)
    }
    
    deinit {
        self._reuse.destroy()
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return available.apply(width: self.width, height: self.height)
    }
    
    public func appear(to layout: ILayout) {
        self.layout = layout
        self.toolbar?.appear(to: self)
        self._onAppear?()
    }
    
    public func disappear() {
        self.toolbar?.disappear()
        self._reuse.disappear()
        self.layout = nil
        self._onDisappear?()
    }
    
    public func visible() {
        self.isVisible = true
        self._onVisible?()
    }
    
    public func visibility() {
        self._onVisibility?()
    }
    
    public func invisible() {
        self.isVisible = false
        self._onInvisible?()
    }
    
    @discardableResult
    public func startEditing() -> Self {
        self._view.becomeFirstResponder()
        return self
    }
    
    @discardableResult
    public func endEditing() -> Self {
        self._view.endEditing(false)
        return self
    }
    
    @discardableResult
    public func width(_ value: DimensionBehaviour) -> Self {
        self.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: DimensionBehaviour) -> Self {
        self.height = value
        return self
    }
    
    @discardableResult
    public func mode(_ value: InputDateViewMode) -> Self {
        self.mode = value
        return self
    }
    
    @discardableResult
    public func minimumDate(_ value: Date?) -> Self {
        self.minimumDate = value
        return self
    }
    
    @discardableResult
    public func maximumDate(_ value: Date?) -> Self {
        self.maximumDate = value
        return self
    }
    
    @discardableResult
    public func selectedDate(_ value: Date?) -> Self {
        self.selectedDate = value
        return self
    }
    
    @discardableResult
    public func formatter(_ value: DateFormatter) -> Self {
        self.formatter = value
        return self
    }
    
    @discardableResult
    public func locale(_ value: Locale) -> Self {
        self.locale = value
        return self
    }
    
    @discardableResult
    public func calendar(_ value: Calendar) -> Self {
        self.calendar = value
        return self
    }
    
    @discardableResult
    public func timeZone(_ value: TimeZone?) -> Self {
        self.timeZone = value
        return self
    }
    
    @discardableResult
    public func textFont(_ value: Font) -> Self {
        self.textFont = value
        return self
    }
    
    @discardableResult
    public func textColor(_ value: Color) -> Self {
        self.textColor = value
        return self
    }
    
    @discardableResult
    public func textInset(_ value: InsetFloat) -> Self {
        self.textInset = value
        return self
    }
    
    @discardableResult
    public func placeholder(_ value: InputPlaceholder) -> Self {
        self.placeholder = value
        return self
    }
    
    @discardableResult
    public func placeholderInset(_ value: InsetFloat?) -> Self {
        self.placeholderInset = value
        return self
    }
    
    @discardableResult
    public func alignment(_ value: TextAlignment) -> Self {
        self.alignment = value
        return self
    }
        
    #if os(iOS)
    
    @discardableResult
    public func toolbar(_ value: IInputToolbarView?) -> Self {
        self.toolbar = value
        return self
    }
    
    #endif
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self.border = value
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self.shadow = value
        return self
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._onAppear = value
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._onDisappear = value
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._onVisible = value
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._onVisibility = value
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._onInvisible = value
        return self
    }
    
    @discardableResult
    public func onBeginEditing(_ value: (() -> Void)?) -> Self {
        self._onBeginEditing = value
        return self
    }
    
    @discardableResult
    public func onEditing(_ value: (() -> Void)?) -> Self {
        self._onEditing = value
        return self
    }
    
    @discardableResult
    public func onEndEditing(_ value: (() -> Void)?) -> Self {
        self._onEndEditing = value
        return self
    }

}

extension InputDateView: InputDateViewDelegate {
    
    func beginEditing() {
        self._onBeginEditing?()
    }
    
    func select(date: Date) {
        self._selectedDate = date
        self._onEditing?()
    }
    
    func endEditing() {
        self._onEndEditing?()
    }
    
}
