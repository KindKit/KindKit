//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKInputDateViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputDateView)
    func select(_ view: KKInputDateView, date: Foundation.Date)
    func endEditing(_ view: KKInputDateView)
    
}

public extension UI.View.Input {
    
    final class Date : IUIView, IUIViewReusable, IUIViewInputable, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set { self._reuse.cache = newValue }
            get { return self._reuse.cache }
        }
        public var reuseName: Swift.String? {
            set { self._reuse.name = newValue }
            get { return self._reuse.name }
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
        public var height: UI.Size.Static = .fixed(28) {
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
        public var mode: Mode = .dateTime {
            didSet {
                guard self.mode != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(mode: self.mode)
                }
            }
        }
        public var minimumDate: Foundation.Date? {
            didSet {
                guard self.minimumDate != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(minimumDate: self.minimumDate)
                }
            }
        }
        public var maximumDate: Foundation.Date? {
            didSet {
                guard self.maximumDate != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(maximumDate: self.maximumDate)
                }
            }
        }
        public var selectedDate: Foundation.Date? {
            set {
                guard self.maximumDate != newValue else { return }
                self._selectedDate = newValue
                if self.isLoaded == true {
                    self._view.update(selectedDate: self._selectedDate)
                }
            }
            get { return self._selectedDate }
        }
        public var formatter: DateFormatter = DateFormatter.kk_make(format: "MM-dd-yyyy HH:mm") {
            didSet {
                guard self.formatter != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(formatter: self.formatter)
                }
            }
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
        public var textInset: InsetFloat = Inset(horizontal: 8, vertical: 4) {
            didSet {
                guard self.textInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textInset: self.textInset)
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
        public var placeholderInset: InsetFloat? {
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
        public var onAppear: ((UI.View.Input.Date) -> Void)?
        public var onDisappear: ((UI.View.Input.Date) -> Void)?
        public var onVisible: ((UI.View.Input.Date) -> Void)?
        public var onVisibility: ((UI.View.Input.Date) -> Void)?
        public var onInvisible: ((UI.View.Input.Date) -> Void)?
        public var onBeginEditing: ((UI.View.Input.Date) -> Void)?
        public var onEditing: ((UI.View.Input.Date) -> Void)?
        public var onEndEditing: ((UI.View.Input.Date) -> Void)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _selectedDate: Foundation.Date?
        
        public init() {
        }
        
        public convenience init(
            configure: (UI.View.Input.Date) -> Void
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

public extension UI.View.Input.Date {
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minimumDate(_ value: Foundation.Date?) -> Self {
        self.minimumDate = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maximumDate(_ value: Foundation.Date?) -> Self {
        self.maximumDate = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedDate(_ value: Foundation.Date?) -> Self {
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
    
#endif
    
}

public extension UI.View.Input.Date {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onBeginEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ value: ((UI.View.Input.Date) -> Void)?) -> Self {
        self.onEndEditing = value
        return self
    }
    
}

extension UI.View.Input.Date : KKInputDateViewDelegate {
    
    func beginEditing(_ view: KKInputDateView) {
        self.onBeginEditing?(self)
    }
    
    func select(_ view: KKInputDateView, date: Foundation.Date) {
        self._selectedDate = date
        self.onEditing?(self)
    }
    
    func endEditing(_ view: KKInputDateView) {
        self.onEndEditing?(self)
    }
    
}

#endif
