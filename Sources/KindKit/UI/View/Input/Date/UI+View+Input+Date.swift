//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKInputDateViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputDateView)
    func editing(_ view: KKInputDateView, value: Foundation.Date)
    func endEditing(_ view: KKInputDateView)
    
}

public extension UI.View.Input {
    
    final class Date {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Static = .init(.fill, .fixed(28)) {
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
        public var formatter: Formatter.String.Date = .init().format("MM-dd-yyyy HH:mm") {
            didSet {
                guard self.formatter != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(formatter: self.formatter)
                }
            }
        }
        public var minimum: Foundation.Date? {
            didSet {
                guard self.minimum != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(minimum: self.minimum)
                }
            }
        }
        public var maximum: Foundation.Date? {
            didSet {
                guard self.maximum != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(maximum: self.maximum)
                }
            }
        }
        public var `default`: Foundation.Date? {
            didSet {
                guard self.default != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(default: self.default)
                }
            }
        }
        public var value: Foundation.Date? {
            set {
                guard self._value != newValue else { return }
                self._value = newValue
                if self.isLoaded == true {
                    self._view.update(value: self._value)
                }
            }
            get { self._value }
        }
        public var textFont: UI.Font = .init(weight: .regular) {
            didSet {
                guard self.textFont != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textFont: self.textFont)
                }
            }
        }
        public var textColor: UI.Color = .black {
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
        public var placeholder: Swift.String? {
            didSet {
                guard self.placeholder != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholder: self.placeholder)
                }
            }
        }
        public var placeholderFont: UI.Font? {
            didSet {
                guard self.placeholderFont != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholderFont: self.placeholderFont)
                }
            }
        }
        public var placeholderColor: UI.Color? {
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
        public var alignment: UI.Text.Alignment = .left {
            didSet {
                guard self.alignment != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(alignment: self.alignment)
                }
            }
        }
#if os(iOS)
        public var toolbar: UI.View.Input.Toolbar? {
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
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        public let onBeginEditing = Signal.Empty< Void >()
        public let onEditing = Signal.Empty< Void >()
        public let onEndEditing = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _value: Foundation.Date?
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Input.Date {
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: () -> Mode) -> Self {
        return self.mode(value())
    }

    @inlinable
    @discardableResult
    func mode(_ value: (Self) -> Mode) -> Self {
        return self.mode(value(self))
    }
    
    @inlinable
    @discardableResult
    func formatter(_ value: Formatter.String.Date) -> Self {
        self.formatter = value
        return self
    }
    
    @inlinable
    @discardableResult
    func formatter(_ value: () -> Formatter.String.Date) -> Self {
        return self.formatter(value())
    }

    @inlinable
    @discardableResult
    func formatter(_ value: (Self) -> Formatter.String.Date) -> Self {
        return self.formatter(value(self))
    }
    
    @inlinable
    @discardableResult
    func minimum(_ value: Foundation.Date?) -> Self {
        self.minimum = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minimum(_ value: () -> Foundation.Date?) -> Self {
        return self.minimum(value())
    }

    @inlinable
    @discardableResult
    func minimum(_ value: (Self) -> Foundation.Date?) -> Self {
        return self.minimum(value(self))
    }
    
    @inlinable
    @discardableResult
    func maximum(_ value: Foundation.Date?) -> Self {
        self.maximum = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maximum(_ value: () -> Foundation.Date?) -> Self {
        return self.maximum(value())
    }

    @inlinable
    @discardableResult
    func maximum(_ value: (Self) -> Foundation.Date?) -> Self {
        return self.maximum(value(self))
    }
    
    @inlinable
    @discardableResult
    func `default`(_ value: Foundation.Date?) -> Self {
        self.default = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `default`(_ value: () -> Foundation.Date?) -> Self {
        return self.default(value())
    }

    @inlinable
    @discardableResult
    func `default`(_ value: (Self) -> Foundation.Date?) -> Self {
        return self.default(value(self))
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Foundation.Date?) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> Foundation.Date?) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> Foundation.Date?) -> Self {
        return self.value(value(self))
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: UI.Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: () -> UI.Font) -> Self {
        return self.textFont(value())
    }

    @inlinable
    @discardableResult
    func textFont(_ value: (Self) -> UI.Font) -> Self {
        return self.textFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: UI.Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: () -> UI.Color) -> Self {
        return self.textColor(value())
    }

    @inlinable
    @discardableResult
    func textColor(_ value: (Self) -> UI.Color) -> Self {
        return self.textColor(value(self))
    }
    
    @inlinable
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
    func placeholder(_ value: Swift.String?) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: () -> Swift.String?) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder(_ value: (Self) -> Swift.String?) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : IEnumLocalized >(_ value: Placeholder) -> Self {
        self.placeholder = value.localized
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : IEnumLocalized >(_ value: () -> Placeholder) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder< Placeholder : IEnumLocalized >(_ value: (Self) -> Placeholder) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: UI.Font?) -> Self {
        self.placeholderFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: () -> UI.Font?) -> Self {
        return self.placeholderFont(value())
    }

    @inlinable
    @discardableResult
    func placeholderFont(_ value: (Self) -> UI.Font?) -> Self {
        return self.placeholderFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: UI.Color?) -> Self {
        self.placeholderColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: () -> UI.Color?) -> Self {
        return self.placeholderColor(value())
    }

    @inlinable
    @discardableResult
    func placeholderColor(_ value: (Self) -> UI.Color?) -> Self {
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
    func alignment(_ value: UI.Text.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> UI.Text.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> UI.Text.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func toolbar(_ value: UI.View.Input.Toolbar?) -> Self {
        self.toolbar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: () -> UI.View.Input.Toolbar?) -> Self {
        return self.toolbar(value())
    }

    @inlinable
    @discardableResult
    func toolbar(_ value: (Self) -> UI.View.Input.Toolbar?) -> Self {
        return self.toolbar(value(self))
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: [IUIViewInputToolbarItem]) -> Self {
        self.toolbar = .toolbar(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: () -> [IUIViewInputToolbarItem]) -> Self {
        self.toolbar = .toolbar(value())
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: (Self) -> [IUIViewInputToolbarItem]) -> Self {
        self.toolbar = .toolbar(value(self))
        return self
    }
    
#endif
    
}

public extension UI.View.Input.Date {
    
    @inlinable
    @available(*, deprecated, renamed: "UI.View.Input.Date.value")
    var selected: Foundation.Date? {
        set { self.value = newValue }
        get { self.value }
    }
    
    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Date.value(_:)")
    func selected(_ value: Foundation.Date?) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Date.value(_:)")
    func selected(_ value: () -> Foundation.Date?) -> Self {
        return self.selected(value())
    }

    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Date.value(_:)")
    func selected(_ value: (Self) -> Foundation.Date?) -> Self {
        return self.selected(value(self))
    }
    
}

extension UI.View.Input.Date : IUIView {
    
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
    
    public func appear(to layout: IUILayout) {
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

extension UI.View.Input.Date : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: Swift.String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension UI.View.Input.Date : IUIViewTransformable {
}

#endif

extension UI.View.Input.Date : IUIViewStaticSizeable {
}

extension UI.View.Input.Date : IUIViewInputable {
    
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

extension UI.View.Input.Date : KKInputDateViewDelegate {
    
    func beginEditing(_ view: KKInputDateView) {
        self.onBeginEditing.emit()
    }
    
    func editing(_ view: KKInputDateView, value: Foundation.Date) {
        self._value = value
        self.onEditing.emit()
    }
    
    func endEditing(_ view: KKInputDateView) {
        self.onEndEditing.emit()
    }
    
}

public extension IUIView where Self == UI.View.Input.Date {
    
    @inlinable
    static func inputDate() -> Self {
        return .init()
    }
    
}

#endif
