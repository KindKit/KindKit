//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKSegmentedViewDelegate : AnyObject {
    
    func selected(_ view: KKSegmentedView, index: Int)
    
}

public extension UI.View {

    final class Segmented : IUIView, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable, IUIViewLockable {
        
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
        public var width: UI.Size.Static = .fill {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fixed(32) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var items: [Item] = [] {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(items: self.items)
            }
        }
        public var selected: Item? {
            set(value) {
                self._selected = value
                guard self.isLoaded == true else { return }
                self._view.update(items: self.items, selected: self._selected)
            }
            get { return self._selected }
        }
        public var isLocked: Bool = false {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(locked: self.isLocked)
            }
        }
        public var color: UI.Color? = nil {
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
        private var _selected: Item?
        private var _onAppear: ((UI.View.Segmented) -> Void)?
        private var _onDisappear: ((UI.View.Segmented) -> Void)?
        private var _onVisible: ((UI.View.Segmented) -> Void)?
        private var _onVisibility: ((UI.View.Segmented) -> Void)?
        private var _onInvisible: ((UI.View.Segmented) -> Void)?
        private var _onChangeStyle: ((UI.View.Segmented, Bool) -> Void)?
        private var _onSelect: ((UI.View.Segmented, Item) -> Void)?
        
        public init() {
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
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
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self._onChangeStyle?(self, userInteraction)
        }
        
        public func onAppear(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        public func onDisappear(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Segmented) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onChangeStyle(_ value: ((UI.View.Segmented, Bool) -> Void)?) -> Self {
            self._onChangeStyle = value
            return self
        }
        
        @discardableResult
        public func onSelect(_ value: ((UI.View.Segmented, Item) -> Void)?) -> Self {
            self._onSelect = value
            return self
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

extension UI.View.Segmented : KKSegmentedViewDelegate {
    
    func selected(_ view: KKSegmentedView, index: Int) {
        let selected = self.items[index]
        self._selected = selected
        self._onSelect?(self, selected)
    }
    
}

#endif
