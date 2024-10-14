//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKInputTextViewDelegate : AnyObject {
    
    func change(_ view: KKInputTextView, textHeight: Double)
    
    func shouldReplace(_ view: KKInputTextView, info: UI.View.Input.Text.ShouldReplace) -> Bool
    
    func beginEditing(_ view: KKInputTextView)
    func editing(_ view: KKInputTextView, value: String)
    func endEditing(_ view: KKInputTextView)
    
}

public extension UI.View.Input {
    
    final class Text {
        
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
        public var size: UI.Size.Dynamic = .init(.fill, .fixed(64)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var minHeight: Double? {
            didSet {
                guard self.minHeight != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var maxHeight: Double? {
            didSet {
                guard self.maxHeight != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var value: Swift.String {
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
        public var editingColor: UI.Color? {
            didSet {
                guard self.editingColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(editingColor: self.editingColor)
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
        public var keyboard: UI.View.Input.Keyboard? {
            didSet {
                guard self.keyboard != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(keyboard: self.keyboard)
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
        public let onShouldReplace = Signal.Args< Bool?, ShouldReplace >()
        public let onBeginEditing = Signal.Empty< Void >()
        public let onEditing = Signal.Empty< Void >()
        public let onEndEditing = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _value: Swift.String = ""
        private var _textHeight: Double = 0
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Input.Text {
    
    @inlinable
    @discardableResult
    func minHeight(_ value: Double) -> Self {
        self.minHeight = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minHeight(_ value: () -> Double) -> Self {
        return self.minHeight(value())
    }
    
    @inlinable
    @discardableResult
    func minHeight(_ value: (Self) -> Double) -> Self {
        return self.minHeight(value(self))
    }
    
    @inlinable
    @discardableResult
    func maxHeight(_ value: Double) -> Self {
        self.maxHeight = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maxHeight(_ value: () -> Double) -> Self {
        return self.maxHeight(value())
    }
    
    @inlinable
    @discardableResult
    func maxHeight(_ value: (Self) -> Double) -> Self {
        return self.maxHeight(value(self))
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Swift.String) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> Swift.String) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> Swift.String) -> Self {
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
    func editingColor(_ value: UI.Color?) -> Self {
        self.editingColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func editingColor(_ value: () -> UI.Color?) -> Self {
        return self.editingColor(value())
    }

    @inlinable
    @discardableResult
    func editingColor(_ value: (Self) -> UI.Color?) -> Self {
        return self.editingColor(value(self))
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
    
    @inlinable
    @discardableResult
    func keyboard(_ value: UI.View.Input.Keyboard?) -> Self {
        self.keyboard = value
        return self
    }
    
    @inlinable
    @discardableResult
    func keyboard(_ value: () -> UI.View.Input.Keyboard?) -> Self {
        return self.keyboard(value())
    }

    @inlinable
    @discardableResult
    func keyboard(_ value: (Self) -> UI.View.Input.Keyboard?) -> Self {
        return self.keyboard(value(self))
    }
    
#endif
    
}

public extension UI.View.Input.Text {
    
    @inlinable
    @discardableResult
    func onShouldReplace(_ closure: ((ShouldReplace) -> Bool?)?) -> Self {
        self.onShouldReplace.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldReplace(_ closure: @escaping (Self, ShouldReplace) -> Bool?) -> Self {
        self.onShouldReplace.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldReplace< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, ShouldReplace) -> Bool?) -> Self {
        self.onShouldReplace.link(sender, closure)
        return self
    }
    
}

public extension UI.View.Input.Text {
    
    @inlinable
    @available(*, deprecated, renamed: "UI.View.Input.Text.value")
    var text: Swift.String {
        set { self.value = newValue }
        get { self.value }
    }
    
    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Text.value(_:)")
    func text(_ value: Swift.String) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Text.value(_:)")
    func text(_ value: () -> Swift.String) -> Self {
        return self.text(value())
    }

    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Text.value(_:)")
    func text(_ value: (Self) -> Swift.String) -> Self {
        return self.text(value(self))
    }
    
}

extension UI.View.Input.Text : IUIView {
    
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
        return self.size.apply(
            available: available,
            size: {
                let size = self._value.kk_size(
                    font: self.textFont,
                    numberOfLines: 0,
                    available: $0.inset(self.textInset)
                )
                switch (self.minHeight, self.maxHeight) {
                case (.some(let minHeight), .some(let maxHeight)):
                    return .init(
                        width: size.width,
                        height: max(minHeight, min(size.height, maxHeight))
                    )
                case (.some(let minHeight), .none):
                    return .init(
                        width: size.width,
                        height: max(minHeight, size.height)
                    )
                case (.none, .some(let maxHeight)):
                    return .init(
                        width: size.width,
                        height: min(size.height, maxHeight)
                    )
                case (.none, .none):
                    return size
                }
            }
        )
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

extension UI.View.Input.Text : IUIViewReusable {
    
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

extension UI.View.Input.Text : IUIViewTransformable {
}

#endif

extension UI.View.Input.Text : IUIViewDynamicSizeable {
}

extension UI.View.Input.Text : IUIViewInputable {
    
    public var isEditing: Bool {
        guard self.isLoaded == true else { return false }
        return self._view.isFirstResponder
    }
    
    @discardableResult
    public func startEditing() -> Self {
        _ = self._view.becomeFirstResponder()
        return self
    }
    
    @discardableResult
    public func endEditing() -> Self {
        self._view.endEditing(false)
        return self
    }
    
}

extension UI.View.Input.Text : KKInputTextViewDelegate {
    
    func change(_ view: KKInputTextView, textHeight: Double) {
        if self._textHeight != textHeight {
            self._textHeight = textHeight
            if self.size.isStatic == false {
                self.setNeedLayout()
            }
        }
    }
    
    func shouldReplace(_ view: KKInputTextView, info: ShouldReplace) -> Bool {
        return self.onShouldReplace.emit(info, default: true)
    }
    
    func beginEditing(_ view: KKInputTextView) {
        self.onBeginEditing.emit()
    }
    
    func editing(_ view: KKInputTextView, value: Swift.String) {
        if self._value != value {
            self._value = value
            self.onEditing.emit()
        }
    }
    
    func endEditing(_ view: KKInputTextView) {
        self.onEndEditing.emit()
    }
    
}

public extension IUIView where Self == UI.View.Input.Text {
    
    @inlinable
    static func inputText() -> Self {
        return .init()
    }
    
}

#endif
