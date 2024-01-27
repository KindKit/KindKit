//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath
import KindSuggestion

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKInputStringViewDelegate : AnyObject {
    
    func shouldReplace(_ view: KKInputStringView, info: StringInputView.ShouldReplace) -> Bool
    
    func beginEditing(_ view: KKInputStringView)
    func editing(_ view: KKInputStringView, value: String)
    func endEditing(_ view: KKInputStringView)
    func pressedReturn(_ view: KKInputStringView)
    func pressed(_ view: KKInputStringView, suggestion: String, index: Int)
    
}

public final class StringInputView {
    
    public private(set) weak var appearedLayout: Layout?
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(transform: self.transform)
            }
        }
    }
#endif
    public var size: StaticSize = .init(.fill, .fixed(28)) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var value: String {
        set {
            guard self.value != newValue else { return }
            self._value = newValue
            if self.isLoaded == true {
                self._view.update(value: self._value)
            }
        }
        get { self._value }
    }
    public var textFont: Font = .init(weight: .regular) {
        didSet {
            guard self.textFont != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(textFont: self.textFont)
            }
        }
    }
    public var textColor: Color = .black {
        didSet {
            guard self.textColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(textColor: self.textColor)
            }
        }
    }
    public var textInset: Inset = Inset(horizontal: 8, vertical: 4) {
        didSet {
            guard self.textInset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(textInset: self.textInset)
            }
        }
    }
    public var editingColor: Color? {
        didSet {
            guard self.editingColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(editingColor: self.editingColor)
            }
        }
    }
    public var placeholder: String? {
        didSet {
            guard self.placeholder != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(placeholder: self.placeholder)
            }
        }
    }
    public var placeholderFont: Font? {
        didSet {
            guard self.placeholderFont != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(placeholderFont: self.placeholderFont)
            }
        }
    }
    public var placeholderColor: Color? {
        didSet {
            guard self.placeholderColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(placeholderColor: self.placeholderColor)
            }
        }
    }
    public var placeholderInset: Inset? {
        didSet {
            guard self.placeholderInset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(placeholderInset: self.placeholderInset)
            }
        }
    }
    public var alignment: Text.Alignment = .left {
        didSet {
            guard self.alignment != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(alignment: self.alignment)
            }
        }
    }
#if os(iOS)
    public var toolbar: InputToolbarView? {
        didSet {
            guard self.toolbar !== oldValue else { return }
            if self.isLoaded == true {
                self._view.update(toolbar: self.toolbar)
            }
        }
    }
    public var keyboard: InputKeyboard? {
        didSet {
            guard self.keyboard != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(keyboard: self.keyboard, suggestion: self.suggestion)
            }
        }
    }
#endif
    public var suggestion: KindSuggestion.IEntity? {
        didSet {
            guard self.toolbar !== oldValue else { return }
            if self.isLoaded == true {
                self._view.update(keyboard: self.keyboard, suggestion: self.suggestion)
            }
        }
    }
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public private(set) var isVisible: Bool = false
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    public let onShouldReplace = Signal< Bool?, ShouldReplace >()
    public let onBeginEditing = Signal< Void, Void >()
    public let onEditing = Signal< Void, Void >()
    public let onEndEditing = Signal< Void, Void >()
    public let onPressedReturn = Signal< Void, Void >()
    public let onSuggestion = Signal< Void, Int >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _value: Swift.String = ""
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension StringInputView {
    
    @inlinable
    @discardableResult
    func value(_ value: String) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> String) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> String) -> Self {
        return self.value(value(self))
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: () -> Font) -> Self {
        return self.textFont(value())
    }

    @inlinable
    @discardableResult
    func textFont(_ value: (Self) -> Font) -> Self {
        return self.textFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: () -> Color) -> Self {
        return self.textColor(value())
    }

    @inlinable
    @discardableResult
    func textColor(_ value: (Self) -> Color) -> Self {
        return self.textColor(value(self))
    }
    
    @discardableResult
    func textInset(_ value: Inset) -> Self {
        self.textInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textInset(_ value: () -> Inset) -> Self {
        return self.textInset(value())
    }

    @inlinable
    @discardableResult
    func textInset(_ value: (Self) -> Inset) -> Self {
        return self.textInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func editingColor(_ value: Color?) -> Self {
        self.editingColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func editingColor(_ value: () -> Color?) -> Self {
        return self.editingColor(value())
    }

    @inlinable
    @discardableResult
    func editingColor(_ value: (Self) -> Color?) -> Self {
        return self.editingColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: String?) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: () -> String?) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder(_ value: (Self) -> String?) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : ILocalized >(_ value: Placeholder) -> Self {
        self.placeholder = value.localized
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : ILocalized >(_ value: () -> Placeholder) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder< Placeholder : ILocalized >(_ value: (Self) -> Placeholder) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: Font?) -> Self {
        self.placeholderFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: () -> Font?) -> Self {
        return self.placeholderFont(value())
    }

    @inlinable
    @discardableResult
    func placeholderFont(_ value: (Self) -> Font?) -> Self {
        return self.placeholderFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: Color?) -> Self {
        self.placeholderColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: () -> Color?) -> Self {
        return self.placeholderColor(value())
    }

    @inlinable
    @discardableResult
    func placeholderColor(_ value: (Self) -> Color?) -> Self {
        return self.placeholderColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(_ value: Inset?) -> Self {
        self.placeholderInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(_ value: () -> Inset?) -> Self {
        return self.placeholderInset(value())
    }

    @inlinable
    @discardableResult
    func placeholderInset(_ value: (Self) -> Inset?) -> Self {
        return self.placeholderInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: Text.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> Text.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> Text.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func toolbar(_ value: InputToolbarView?) -> Self {
        self.toolbar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: () -> InputToolbarView?) -> Self {
        return self.toolbar(value())
    }

    @inlinable
    @discardableResult
    func toolbar(_ value: (Self) -> InputToolbarView?) -> Self {
        return self.toolbar(value(self))
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: [IInputToolbarItem]) -> Self {
        if value.isEmpty == false {
            self.toolbar = .init().items(value)
        } else {
            self.toolbar = nil
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: () -> [IInputToolbarItem]) -> Self {
        return self.toolbar(value())
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: (Self) -> [IInputToolbarItem]) -> Self {
        return self.toolbar(value(self))
    }
    
    @inlinable
    @discardableResult
    func keyboard(_ value: InputKeyboard?) -> Self {
        self.keyboard = value
        return self
    }
    
    @inlinable
    @discardableResult
    func keyboard(_ value: () -> InputKeyboard?) -> Self {
        return self.keyboard(value())
    }

    @inlinable
    @discardableResult
    func keyboard(_ value: (Self) -> InputKeyboard?) -> Self {
        return self.keyboard(value(self))
    }
    
#endif
    
    @inlinable
    @discardableResult
    func suggestion(_ value: KindSuggestion.IEntity?) -> Self {
        self.suggestion = value
        return self
    }
    
    @inlinable
    @discardableResult
    func suggestion(_ value: () -> KindSuggestion.IEntity?) -> Self {
        return self.suggestion(value())
    }

    @inlinable
    @discardableResult
    func suggestion(_ value: (Self) -> KindSuggestion.IEntity?) -> Self {
        return self.suggestion(value(self))
    }
    
}

public extension StringInputView {
    
    @inlinable
    @discardableResult
    func onShouldReplace(_ closure: @escaping (ShouldReplace) -> Bool?) -> Self {
        self.onShouldReplace.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldReplace(_ closure: @escaping (Self, ShouldReplace) -> Bool?) -> Self {
        self.onShouldReplace.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldReplace< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, ShouldReplace) -> Bool?) -> Self {
        self.onShouldReplace.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressedReturn(_ closure: @escaping () -> Void) -> Self {
        self.onPressedReturn.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressedReturn(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressedReturn.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressedReturn< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressedReturn.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSuggestion(_ closure: @escaping (Int) -> Void) -> Self {
        self.onSuggestion.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSuggestion(_ closure: @escaping (Self, Int) -> Void) -> Self {
        self.onSuggestion.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSuggestion< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Int) -> Void) -> Self {
        self.onSuggestion.add(sender, closure)
        return self
    }
    
}

extension StringInputView : IView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(available: available)
    }
    
    public func appear(to layout: Layout) {
        self.appearedLayout = layout
#if os(iOS)
        self.toolbar?.appear(to: self)
#endif
        self.onAppear.emit()
    }
    
    public func disappear() {
#if os(iOS)
        self.toolbar?.disappear()
#endif
        self._reuse.disappear()
        self.appearedLayout = nil
        self.onDisappear.emit()
    }
    
    public func visible() {
        self.isVisible = true
        self.onVisible.emit()
    }
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension StringInputView : IViewReusable {
    
    public var reuseUnloadBehaviour: Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: ReuseCache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: Swift.String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension StringInputView : IViewSupportTransform {
}

#endif

extension StringInputView : IViewSupportStaticSize {
}

extension StringInputView : IViewInputable {
    
    public var isEditing: Bool {
        guard self.isLoaded == true else { return false }
        return self._view.isFirstResponder
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
    
}

extension StringInputView : KKInputStringViewDelegate {
    
    func shouldReplace(_ view: KKInputStringView, info: ShouldReplace) -> Bool {
        return self.onShouldReplace.emit(info, default: true)
    }
    
    func beginEditing(_ view: KKInputStringView) {
        self.onBeginEditing.emit()
        self.suggestion?.begin()
    }
    
    func editing(_ view: KKInputStringView, value: String) {
        if self._value != value {
            self._value = value
            self.onEditing.emit()
        }
    }
    
    func endEditing(_ view: KKInputStringView) {
        self.suggestion?.end()
        self.onEndEditing.emit()
    }
    
    func pressedReturn(_ view: KKInputStringView) {
        self.onPressedReturn.emit()
    }
    
    func pressed(_ view: KKInputStringView, suggestion: String, index: Int) {
        if self._value != suggestion {
            self._value = suggestion
            self.onEditing.emit()
        }
        self.onSuggestion.emit(index)
        self.onPressedReturn.emit()
    }
    
}

#endif
