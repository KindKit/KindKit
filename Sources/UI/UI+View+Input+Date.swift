//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKInputDateViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputDateView)
    func select(_ view: KKInputDateView, date: Foundation.Date)
    func endEditing(_ view: KKInputDateView)
    
}

public extension UI.View.Input {
    
    final class Date {
        
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Static = .init(width: .fill, height: .fixed(28)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
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
        public var formatter: DateFormatter = DateFormatter.kk_make(format: "MM-dd-yyyy HH:mm") {
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
        public var selected: Foundation.Date? {
            set {
                guard self._selected != newValue else { return }
                self._selected = newValue
                if self.isLoaded == true {
                    self._view.update(selected: self._selected)
                }
            }
            get { self._selected }
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
        public var placeholder: UI.View.Input.Placeholder? {
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
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onBeginEditing: Signal.Empty< Void > = .init()
        public let onEditing: Signal.Empty< Void > = .init()
        public let onEndEditing: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _selected: Foundation.Date?
        
        public init() {
        }
        
        @inlinable
        public convenience init(
            configure: (UI.View.Input.Date) -> Void
        ) {
            self.init()
            self.modify(configure)
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
    func formatter(_ value: DateFormatter) -> Self {
        self.formatter = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minimum(_ value: Foundation.Date?) -> Self {
        self.minimum = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maximum(_ value: Foundation.Date?) -> Self {
        self.maximum = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: Foundation.Date?) -> Self {
        self.selected = value
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

extension UI.View.Input.Date : IUIView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
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
    
    public func visibility() {
        self.onVisibility.emit()
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
    
    func select(_ view: KKInputDateView, date: Foundation.Date) {
        self._selected = date
        self.onEditing.emit()
    }
    
    func endEditing(_ view: KKInputDateView) {
        self.onEndEditing.emit()
    }
    
}

#endif
