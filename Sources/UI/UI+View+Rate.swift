//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {

    final class Rate : IUIView, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var itemSize: SizeFloat = .init(width: 40, height: 40) {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(itemSize: self.itemSize)
                self.setNeedForceLayout()
            }
        }
        public var itemSpacing: Float = 2 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(itemSpacing: self.itemSpacing)
                self.setNeedForceLayout()
            }
        }
        public var numberOfItem: UInt = 0 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(numberOfItem: self.numberOfItem)
                self.setNeedForceLayout()
            }
        }
        public var rounding: Rounding = .down {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(rounding: self.rounding)
            }
        }
        public var states: [State] {
            set(value) {
                guard self.isLoaded == true else { return }
                self._states = Self._sort(states: value)
                self._view.update(states: self._states)
            }
            get { return self._states }
        }
        public var rating: Float = 0 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(rating: self.rating)
            }
        }
        public var color: Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
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
        private var _states: [State] = []
        private var _onAppear: ((UI.View.Rate) -> Void)?
        private var _onDisappear: ((UI.View.Rate) -> Void)?
        private var _onVisible: ((UI.View.Rate) -> Void)?
        private var _onVisibility: ((UI.View.Rate) -> Void)?
        private var _onInvisible: ((UI.View.Rate) -> Void)?
        
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
            self.layout = layout
            self._onAppear?(self)
        }
        
        public func disappear() {
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
        public func onAppear(_ value: ((UI.View.Rate) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Rate) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Rate) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Rate) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Rate) -> Void)?) -> Self {
            self._onInvisible = value
            return self
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

private extension UI.View.Rate {
    
    static func _sort(states: [State]) -> [State] {
        return states.sorted(by: { $0.rate < $1.rate })
    }
    
}

#endif
