//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {

    final class Rate : IUIView, IUIViewReusable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(shadow: self.shadow)
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
        public var itemSize: SizeFloat = .init(width: 40, height: 40) {
            didSet {
                guard self.itemSize != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(itemSize: self.itemSize)
                }
                self.setNeedForceLayout()
            }
        }
        public var itemSpacing: Float = 2 {
            didSet {
                guard self.itemSpacing != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(itemSpacing: self.itemSpacing)
                }
                self.setNeedForceLayout()
            }
        }
        public var numberOfItem: UInt = 0 {
            didSet {
                guard self.numberOfItem != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(numberOfItem: self.numberOfItem)
                }
                self.setNeedForceLayout()
            }
        }
        public var rounding: Rounding = .down {
            didSet {
                guard self.rounding != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(rounding: self.rounding)
                }
            }
        }
        public var states: [State] {
            set {
                let value = Self._sort(states: newValue)
                guard self.states != value else { return }
                self._states = value
                if self.isLoaded == true {
                    self._view.update(states: self._states)
                }
            }
            get { return self._states }
        }
        public var rating: Float = 0 {
            didSet {
                guard self.rating != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(rating: self.rating)
                }
            }
        }
        public var onAppear: ((UI.View.Rate) -> Void)?
        public var onDisappear: ((UI.View.Rate) -> Void)?
        public var onVisible: ((UI.View.Rate) -> Void)?
        public var onVisibility: ((UI.View.Rate) -> Void)?
        public var onInvisible: ((UI.View.Rate) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _states: [State] = []
        
        public init() {
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            configure: (UI.View.Rate) -> Void
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
            if self.numberOfItem > 1 {
                return Size(
                    width: (self.itemSize.width * Float(self.numberOfItem)) + (self.itemSpacing * Float(self.numberOfItem - 1)),
                    height: self.itemSize.height
                )
            } else if self.numberOfItem > 0 {
                return self.itemSize
            }
            return .zero
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
        
    }
    
}

public extension UI.View.Rate {
    
    @inlinable
    @discardableResult
    func itemSize(_ value: SizeFloat) -> Self {
        self.itemSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemSpacing(_ value: Float) -> Self {
        self.itemSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfItem(_ value: UInt) -> Self {
        self.numberOfItem = value
        return self
    }
    
    @inlinable
    @discardableResult
    func rounding(_ value: Rounding) -> Self {
        self.rounding = value
        return self
    }
    
    @inlinable
    @discardableResult
    func states(_ value: [State]) -> Self {
        self.states = value
        return self
    }
    
    @inlinable
    @discardableResult
    func rating(_ value: Float) -> Self {
        self.rating = value
        return self
    }
    
}

public extension UI.View.Rate {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Rate) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Rate) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Rate) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Rate) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Rate) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
}

private extension UI.View.Rate {
    
    static func _sort(states: [State]) -> [State] {
        return states.sorted(by: { $0.rate < $1.rate })
    }
    
}

#endif
