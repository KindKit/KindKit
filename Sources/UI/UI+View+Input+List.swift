//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKInputListViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputListView)
    func select(_ view: KKInputListView, item: IInputListItem)
    func endEditing(_ view: KKInputListView)
    
}

public extension UI.View.Input {

    final class List : IUIView, IUIViewInputable, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) unowned var layout: IUILayout?
        public unowned var item: UI.Layout.Item?
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
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
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
        public var height: UI.Size.Static = .fixed(26) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var items: [IInputListItem] = [] {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(items: self.items)
            }
        }
        public var selectedItem: IInputListItem? {
            set(value) {
                self._selectedItem = value
                guard self.isLoaded == true else { return }
                self._view.update(selectedItem: self._selectedItem, userInteraction: false)
            }
            get { return self._selectedItem }
        }
        public var textFont: UI.Font = .init(weight: .regular) {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(textFont: self.textFont)
            }
        }
        public var textColor: UI.Color = .init(rgb: 0x000000) {
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
        public var placeholder: UI.View.Input.Placeholder? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(placeholder: self.placeholder)
            }
        }
        public var placeholderInset: InsetFloat? = nil {
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
        #endif
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
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _selectedItem: IInputListItem?
        private var _onAppear: ((UI.View.Input.List) -> Void)?
        private var _onDisappear: ((UI.View.Input.List) -> Void)?
        private var _onVisible: ((UI.View.Input.List) -> Void)?
        private var _onVisibility: ((UI.View.Input.List) -> Void)?
        private var _onInvisible: ((UI.View.Input.List) -> Void)?
        private var _onBeginEditing: ((UI.View.Input.List) -> Void)?
        private var _onEditing: ((UI.View.Input.List) -> Void)?
        private var _onEndEditing: ((UI.View.Input.List) -> Void)?
        
        public init() {
            self._reuse = UI.Reuse.Item()
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
            return UI.Size.Static.apply(
                available: available,
                width: self.width,
                height: self.height
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.layout = layout
            #if os(iOS)
            self.toolbar?.appear(to: self)
            #endif
            self._onAppear?(self)
        }
        
        public func disappear() {
            #if os(iOS)
            self.toolbar?.disappear()
            #endif
            self._reuse.disappear()
            self.layout = nil
            self._onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self._onVisible?(self)
        }
        
        public func visibility() {
            self._onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self._onInvisible?(self)
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
        public func onAppear(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onBeginEditing(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onBeginEditing = value
            return self
        }
        
        @discardableResult
        public func onEditing(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onEditing = value
            return self
        }
        
        @discardableResult
        public func onEndEditing(_ value: ((UI.View.Input.List) -> Void)?) -> Self {
            self._onEndEditing = value
            return self
        }

    }
    
}

public extension UI.View.Input.List {
    
    @inlinable
    @discardableResult
    func items(_ value: [IInputListItem]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedItem(_ value: IInputListItem?) -> Self {
        self.selectedItem = value
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

extension UI.View.Input.List : KKInputListViewDelegate {
    
    func beginEditing(_ view: KKInputListView) {
        self._onBeginEditing?(self)
    }
    
    func select(_ view: KKInputListView, item: IInputListItem) {
        self._selectedItem = item
        self._view.update(selectedItem: item, userInteraction: true)
        self._onEditing?(self)
    }
    
    func endEditing(_ view: KKInputListView) {
        self._onEndEditing?(self)
    }
    
}

#endif
