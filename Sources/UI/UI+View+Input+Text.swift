//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKInputTextViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputTextView)
    func editing(_ view: KKInputTextView, text: String)
    func endEditing(_ view: KKInputTextView)
    
}

public extension UI.View.Input {
    
    final class Text : IUIView, IUIViewReusable, IUIViewInputable, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var native: NativeView {
            return self._view
        }
        public var isLoaded: Bool {
            return self._reuse.isLoaded
        }
        public var bounds: RectFloat {
            guard self.isLoaded == true else { return .zero }
            return Rect(self._view.bounds)
        }
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
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
        public var isEditing: Bool {
            guard self.isLoaded == true else { return false }
            return self._view.isFirstResponder
        }
        public var width: UI.Size.Static = .fill {
            didSet {
                guard self.width != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(64) {
            didSet {
                guard self.height != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(shadow: self.shadow)
                }
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
            }
        }
        public var text: Swift.String {
            set {
                guard self._text != newValue else { return }
                self._text = newValue
                if self.isLoaded == true {
                    self._view.update(text: self._text)
                }
            }
            get { self._text }
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
        public var textInset: InsetFloat = .init(horizontal: 8, vertical: 4) {
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
        public var placeholder: UI.View.Input.Placeholder? = nil {
            didSet {
                guard self.placeholder != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholder: self.placeholder)
                }
            }
        }
        public var placeholderInset: InsetFloat? = nil {
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
        public var toolbar: UI.View.Input.Toolbar? = nil {
            didSet {
                guard self.toolbar !== oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(toolbar: self.toolbar)
                }
            }
        }
        public var keyboard: UI.View.Input.Keyboard? = nil {
            didSet {
                guard self.keyboard != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(keyboard: self.keyboard)
                }
            }
        }
#endif
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onBeginEditing: Signal.Empty< Void > = .init()
        public let onEditing: Signal.Empty< Void > = .init()
        public let onEndEditing: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _text: Swift.String = ""
        
        public init() {
        }
        
        public convenience init(
            configure: (UI.View.Input.Text) -> Void
        ) {
            self.init()
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Static.apply(
                available: available,
                width: self.width,
                height: self.height
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
        
        public func visibility() {
            self.onVisibility.emit()
        }
        
        public func invisible() {
            self.isVisible = false
            self.onInvisible.emit()
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
    
}

public extension UI.View.Input.Text {
    
    @inlinable
    @discardableResult
    func text(_ value: Swift.String) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: UI.Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: UI.Color) -> Self {
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
    func editingColor(_ value: UI.Color?) -> Self {
        self.editingColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: UI.View.Input.Placeholder?) -> Self {
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
    func alignment(_ value: UI.Text.Alignment) -> Self {
        self.alignment = value
        return self
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
    func keyboard(_ value: UI.View.Input.Keyboard?) -> Self {
        self.keyboard = value
        return self
    }
    
#endif
    
}

extension UI.View.Input.Text : KKInputTextViewDelegate {
    
    func beginEditing(_ view: KKInputTextView) {
        self.onBeginEditing.emit()
    }
    
    func editing(_ view: KKInputTextView, text: Swift.String) {
        if self._text != text {
            self._text = text
            self.onEditing.emit()
        }
    }
    
    func endEditing(_ view: KKInputTextView) {
        self.onEndEditing.emit()
    }
    
}

#endif
