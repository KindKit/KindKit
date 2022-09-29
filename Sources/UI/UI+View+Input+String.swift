//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKInputStringViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputStringView)
    func editing(_ view: KKInputStringView, text: String)
    func endEditing(_ view: KKInputStringView)
    func pressedReturn(_ view: KKInputStringView)
    
}

public extension UI.View.Input {
    
    final class String : IUIView, IUIViewReusable, IUIViewInputable, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
            set(value) { self._reuse.unloadBehaviour = value }
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set(value) { self._reuse.cache = value }
            get { return self._reuse.cache }
        }
        public var reuseName: Swift.String? {
            set(value) { self._reuse.name = value }
            get { return self._reuse.name }
        }
        public var isEditing: Bool {
            guard self.isLoaded == true else { return false }
            return self._view.isFirstResponder
        }
        public var width: UI.Size.Static = .fill {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(29) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var color: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(alpha: self.alpha)
            }
        }
        public var text: Swift.String {
            set(value) {
                self._text = value
                guard self.isLoaded == true else { return }
                self._view.update(text: self._text)
            }
            get { return self._text }
        }
        public var textFont: UI.Font = .init(weight: .regular) {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(textFont: self.textFont)
            }
        }
        public var textColor: UI.Color = .black {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(textColor: self.textColor)
            }
        }
        public var textInset: InsetFloat = Inset(horizontal: 8, vertical: 4) {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(textInset: self.textInset)
            }
        }
        public var editingColor: UI.Color? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(editingColor: self.editingColor)
            }
        }
        public var placeholder: UI.View.Input.Placeholder? = nil {
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
        public var alignment: UI.Text.Alignment = .left {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(alignment: self.alignment)
            }
        }
#if os(iOS)
        public var toolbar: UI.View.Input.Toolbar? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(toolbar: self.toolbar)
            }
        }
        public var keyboard: UI.View.Input.Keyboard? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(keyboard: self.keyboard)
            }
        }
#endif
        public var onAppear: ((UI.View.Input.String) -> Void)?
        public var onDisappear: ((UI.View.Input.String) -> Void)?
        public var onVisible: ((UI.View.Input.String) -> Void)?
        public var onVisibility: ((UI.View.Input.String) -> Void)?
        public var onInvisible: ((UI.View.Input.String) -> Void)?
        public var onBeginEditing: ((UI.View.Input.String) -> Void)?
        public var onEditing: ((UI.View.Input.String) -> Void)?
        public var onEndEditing: ((UI.View.Input.String) -> Void)?
        public var onPressedReturn: ((UI.View.Input.String) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _text: Swift.String = ""
        
        public init() {
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            configure: (UI.View.Input.String) -> Void
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
            self.onAppear?(self)
        }
        
        public func disappear() {
#if os(iOS)
            self.toolbar?.disappear()
#endif
            self._reuse.disappear()
            self.appearedLayout = nil
            self.onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self.onVisible?(self)
        }
        
        public func visibility() {
            self.onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self.onInvisible?(self)
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

public extension UI.View.Input.String {
    
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

public extension UI.View.Input.String {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onBeginEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onEndEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressedReturn(_ value: ((UI.View.Input.String) -> Void)?) -> Self {
        self.onPressedReturn = value
        return self
    }
    
}

extension UI.View.Input.String : KKInputStringViewDelegate {
    
    func beginEditing(_ view: KKInputStringView) {
        self.onBeginEditing?(self)
    }
    
    func editing(_ view: KKInputStringView, text: Swift.String) {
        self._text = text
        self.onEditing?(self)
    }
    
    func endEditing(_ view: KKInputStringView) {
        self.onEndEditing?(self)
    }
    
    func pressedReturn(_ view: KKInputStringView) {
        self.onPressedReturn?(self)
    }
    
}

#endif
