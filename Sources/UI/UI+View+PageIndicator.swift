//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKPageIndicatorViewDelegate : AnyObject {
    
    func changed(_ view: KKPageIndicatorView, currentPage: Float)
    
}

public extension UI.View {

    final class PageIndicator : IUIView, IUIViewReusable, IUIViewStaticSizeable, IUIViewPageable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var reuseName: String? {
            set(value) { self._reuse.name = value }
            get { return self._reuse.name }
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
        public var currentPage: Float {
            set(value) {
                if self._currentPage != value {
                    self._currentPage = value
                    self.linkedPageable?.currentPage = value
                    if self.isLoaded == true {
                        self._view.update(currentPage: self.currentPage)
                    }
                }
            }
            get { return self._currentPage }
        }
        public var numberOfPages: UInt = 0 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(numberOfPages: self.numberOfPages)
            }
        }
        public unowned var linkedPageable: IUIViewPageable? {
            willSet(newValue) {
                guard self.linkedPageable !== newValue else { return }
                self.linkedPageable?.linkedPageable = nil
            }
            didSet(oldValue) {
                guard self.linkedPageable !== oldValue else { return }
                self.linkedPageable?.linkedPageable = self
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
        public var pageColor: UI.Color? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(pageColor: self.pageColor)
            }
        }
        public var currentPageColor: UI.Color? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(currentPageColor: self.currentPageColor)
            }
        }
        public var onAppear: ((UI.View.PageIndicator) -> Void)?
        public var onDisappear: ((UI.View.PageIndicator) -> Void)?
        public var onVisible: ((UI.View.PageIndicator) -> Void)?
        public var onVisibility: ((UI.View.PageIndicator) -> Void)?
        public var onInvisible: ((UI.View.PageIndicator) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _currentPage: Float = 0
        
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

public extension UI.View.PageIndicator {
    
    @inlinable
    @discardableResult
    func pageColor(_ value: UI.Color?) -> Self {
        self.pageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPageColor(_ value: UI.Color?) -> Self {
        self.currentPageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Float) -> Self {
        self.currentPage = value
        return self
    }
    
    @inlinable
    func animate(currentPage: Float, completion: (() -> Void)?) {
        self.currentPage = currentPage
    }
    
}

public extension UI.View.PageIndicator {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.PageIndicator) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.PageIndicator) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.PageIndicator) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.PageIndicator) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.PageIndicator) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
}

extension UI.View.PageIndicator : KKPageIndicatorViewDelegate {
    
    func changed(_ view: KKPageIndicatorView, currentPage: Float) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.linkedPageable?.animate(currentPage: currentPage, completion: nil)
        }
    }
    
}

#endif
