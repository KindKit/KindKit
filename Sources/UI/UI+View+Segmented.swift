//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKSegmentedViewDelegate : AnyObject {
    
    func selected(_ view: KKSegmentedView, index: Int)
    
}

public extension UI.View {

    final class Segmented : IUIView, IUIViewReusable, IUIViewStaticSizeable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var reuseName: String? {
            set { self._reuse.name = newValue }
            get { return self._reuse.name }
        }
        public var width: UI.Size.Static = .fill {
            didSet {
                guard self.width != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(32) {
            didSet {
                guard self.height != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var isLocked: Bool = false {
            didSet {
                guard self.isLocked != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(locked: self.isLocked)
                }
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
        public var items: [Item] = [] {
            didSet {
                guard self.items != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(items: self.items)
                }
                if let selected = self.selected {
                    if self.items.contains(selected) == false {
                        self.selected = self.items.first
                    }
                } else {
                    self.selected = self.items.first
                }
            }
        }
        public var selected: Item? {
            set {
                guard self._selected != newValue else { return }
                self._selected = newValue
                if self.isLoaded == true {
                    self._view.update(selected: self._selected)
                }
            }
            get { return self._selected }
        }
        public var onAppear: ((UI.View.Segmented) -> Void)?
        public var onDisappear: ((UI.View.Segmented) -> Void)?
        public var onVisible: ((UI.View.Segmented) -> Void)?
        public var onVisibility: ((UI.View.Segmented) -> Void)?
        public var onInvisible: ((UI.View.Segmented) -> Void)?
        public var onChangeStyle: ((UI.View.Segmented, Bool) -> Void)?
        public var onSelect: ((UI.View.Segmented, Item) -> Void)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _selected: Item?
        
        public init() {
        }
        
        public convenience init(
            configure: (UI.View.Segmented) -> Void
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
            self.onAppear?(self)
        }
        
        public func disappear() {
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
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self.onChangeStyle?(self, userInteraction)
        }
        
    }
    
}

public extension UI.View.Segmented {
    
    @inlinable
    @discardableResult
    func items(_ value: [Item]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: Item?) -> Self {
        self.selected = value
        return self
    }
    
}

public extension UI.View.Segmented {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((UI.View.Segmented, Bool) -> Void)?) -> Self {
        self.onChangeStyle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ value: ((UI.View.Segmented, Item) -> Void)?) -> Self {
        self.onSelect = value
        return self
    }
    
}

extension UI.View.Segmented : KKSegmentedViewDelegate {
    
    func selected(_ view: KKSegmentedView, index: Int) {
        let selected = self.items[index]
        self._selected = selected
        self.onSelect?(self, selected)
    }
    
}

#endif
