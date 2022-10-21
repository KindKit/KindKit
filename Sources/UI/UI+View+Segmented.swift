//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKSegmentedViewDelegate : AnyObject {
    
    func selected(_ view: KKSegmentedView, index: Int)
    
}

public extension UI.View {

    final class Segmented {
        
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Static = .init(width: .fill, height: .fixed(32)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
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
            get { self._selected }
        }
        public var color: UI.Color? {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(color: self.color)
                }
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(alpha: self.alpha)
                }
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
        public let onStyle: Signal.Args< Void, Bool > = .init()
        public let onSelect: Signal.Args< Void, UI.View.Segmented.Item > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _selected: Item?
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
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
    func onSelect(_ closure: (() -> Void)?) -> Self {
        self.onSelect.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: ((Self) -> Void)?) -> Self {
        self.onSelect.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: ((UI.View.Segmented.Item) -> Void)?) -> Self {
        self.onSelect.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect(_ closure: ((Self, UI.View.Segmented.Item) -> Void)?) -> Self {
        self.onSelect.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onSelect.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelect< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, UI.View.Segmented.Item) -> Void)?) -> Self {
        self.onSelect.link(sender, closure)
        return self
    }
    
}

extension UI.View.Segmented : IUIView {
    
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
        self.onAppear.emit()
    }
    
    public func disappear() {
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

extension UI.View.Segmented : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

extension UI.View.Segmented : IUIViewStaticSizeable {
}

extension UI.View.Segmented : IUIViewLockable {
}

extension UI.View.Segmented : IUIViewColorable {
}

extension UI.View.Segmented : IUIViewAlphable {
}

extension UI.View.Segmented : KKSegmentedViewDelegate {
    
    func selected(_ view: KKSegmentedView, index: Int) {
        let selected = self.items[index]
        if self._selected != selected {
            self._selected = selected
            self.onSelect.emit(selected)
        }
    }
    
}

#endif
