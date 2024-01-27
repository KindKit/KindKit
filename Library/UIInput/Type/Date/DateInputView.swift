//
//  KindKit
//

import Foundation
import KindEvent
import KindGraphics
import KindGeometry
import KindString

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKDateInputViewDelegate : AnyObject {
    
    func kk_beginEditing()
    func kk_endEditing()
    func kk_default() -> Date?
    func kk_changed(selected: Date)
    
}

public final class DateInputView {
    
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
    public var mode: Mode = .dateTime {
        didSet {
            guard self.mode != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(mode: self.mode)
            }
        }
    }
    public var formatter = KindString.DateFormatter().format("MM-dd-yyyy HH:mm") {
        didSet {
            guard self.formatter != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(formatter: self.formatter)
            }
        }
    }
    public var minimum: Date? {
        didSet {
            guard self.minimum != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(minimum: self.minimum)
            }
        }
    }
    public var maximum: Date? {
        didSet {
            guard self.maximum != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(maximum: self.maximum)
            }
        }
    }
    public var `default`: Date? {
        didSet {
            guard self.default != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(default: self.default)
            }
        }
    }
    public var value: Date? {
        set {
            guard self._value != newValue else { return }
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
    public var textInset: Inset = .init(horizontal: 8, vertical: 4) {
        didSet {
            guard self.textInset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(textInset: self.textInset)
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
#endif
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
    public let onBeginEditing = Signal< Void, Void >()
    public let onEditing = Signal< Void, Void >()
    public let onEndEditing = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _value: Date?
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension DateInputView {
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(on: () -> Mode) -> Self {
        self.mode = on()
        return self
    }

    @inlinable
    @discardableResult
    func mode(on: (Self) -> Mode) -> Self {
        self.mode = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func formatter(_ value: KindString.DateFormatter) -> Self {
        self.formatter = value
        return self
    }
    
    @inlinable
    @discardableResult
    func formatter(on: () -> KindString.DateFormatter) -> Self {
        self.formatter = on()
        return self
    }

    @inlinable
    @discardableResult
    func formatter(on: (Self) -> KindString.DateFormatter) -> Self {
        self.formatter = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func minimum(_ value: Date?) -> Self {
        self.minimum = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minimum(on: () -> Date?) -> Self {
        self.minimum = on()
        return self
    }

    @inlinable
    @discardableResult
    func minimum(on: (Self) -> Date?) -> Self {
        self.minimum = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func maximum(_ value: Date?) -> Self {
        self.maximum = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maximum(on: () -> Date?) -> Self {
        self.maximum = on()
        return self
    }

    @inlinable
    @discardableResult
    func maximum(on: (Self) -> Date?) -> Self {
        self.maximum = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func `default`(_ value: Date?) -> Self {
        self.default = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `default`(on: () -> Date?) -> Self {
        self.default = on()
        return self
    }

    @inlinable
    @discardableResult
    func `default`(on: (Self) -> Date?) -> Self {
        self.default = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Date?) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(on: () -> Date?) -> Self {
        self.value = on()
        return self
    }

    @inlinable
    @discardableResult
    func value(on: (Self) -> Date?) -> Self {
        self.value = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: KindGraphics.Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(on: () -> KindGraphics.Font) -> Self {
        self.textFont = on()
        return self
    }

    @inlinable
    @discardableResult
    func textFont(on: (Self) -> KindGraphics.Font) -> Self {
        self.textFont = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: KindGraphics.Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(on: () -> KindGraphics.Color) -> Self {
        self.textColor = on()
        return self
    }

    @inlinable
    @discardableResult
    func textColor(on: (Self) -> KindGraphics.Color) -> Self {
        self.textColor = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func textInset(_ value: Inset) -> Self {
        self.textInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textInset(on: () -> Inset) -> Self {
        self.textInset = on()
        return self
    }

    @inlinable
    @discardableResult
    func textInset(on: (Self) -> Inset) -> Self {
        self.textInset = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: Swift.String?) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(on: () -> Swift.String?) -> Self {
        self.placeholder = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholder(on: (Self) -> Swift.String?) -> Self {
        self.placeholder = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : ILocalized >(_ value: Placeholder) -> Self {
        self.placeholder = value.localized
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : ILocalized >(on: () -> Placeholder) -> Self {
        self.placeholder = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholder< Placeholder : ILocalized >(on: (Self) -> Placeholder) -> Self {
        self.placeholder = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: KindGraphics.Font?) -> Self {
        self.placeholderFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(on: () -> KindGraphics.Font?) -> Self {
        self.placeholderFont = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholderFont(on: (Self) -> KindGraphics.Font?) -> Self {
        self.placeholderFont = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: KindGraphics.Color?) -> Self {
        self.placeholderColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(on: () -> KindGraphics.Color?) -> Self {
        self.placeholderColor = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholderColor(on: (Self) -> KindGraphics.Color?) -> Self {
        self.placeholderColor = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(_ value: Inset?) -> Self {
        self.placeholderInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(on: () -> Inset?) -> Self {
        self.placeholderInset = on()
        return self
    }

    @inlinable
    @discardableResult
    func placeholderInset(on: (Self) -> Inset?) -> Self {
        self.placeholderInset = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: KindGraphics.Text.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(on: () -> KindGraphics.Text.Alignment) -> Self {
        self.alignment = on()
        return self
    }

    @inlinable
    @discardableResult
    func alignment(on: (Self) -> KindGraphics.Text.Alignment) -> Self {
        self.alignment = on(self)
        return self
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
    func toolbar(on: () -> InputToolbarView?) -> Self {
        self.toolbar = on()
        return self
    }

    @inlinable
    @discardableResult
    func toolbar(on: (Self) -> InputToolbarView?) -> Self {
        self.toolbar = on(self)
        return self
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
    func toolbar(on: () -> [IInputToolbarItem]) -> Self {
        self.toolbar = on()
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(on: (Self) -> [IInputToolbarItem]) -> Self {
        self.toolbar = on(self)
        return self
    }
    
#endif
    
}

extension DateInputView : IView {
    
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

extension DateInputView : IViewReusable {
    
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

extension DateInputView : IViewSupportTransform {
}

#endif

extension DateInputView : IViewSupportStaticSize {
}

extension DateInputView : IViewInputable {
    
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

extension DateInputView : KKDateInputViewDelegate {
    
    func beginEditing(_ view: KKDateInputView) {
        self.onBeginEditing.emit()
    }
    
    func editing(_ view: KKDateInputView, value: Date) {
        self._value = value
        self.onEditing.emit()
    }
    
    func endEditing(_ view: KKDateInputView) {
        self.onEndEditing.emit()
    }
    
}

#endif
