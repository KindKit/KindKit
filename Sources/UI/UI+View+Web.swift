//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKWebViewDelegate : AnyObject {
    
    func update(_ view: KKWebView, contentSize: SizeFloat)
    
    func beginLoading(_ view: KKWebView)
    func endLoading(_ view: KKWebView, error: Error?)
    
    func onDecideNavigation(_ view: KKWebView, request: URLRequest) -> UI.View.Web.NavigationPolicy
    
}

public extension UI.View {

    final class Web : IUIView, IUIViewReusable, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var height: UI.Size.Static = .fill {
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
        public var enablePinchGesture: Bool = true {
            didSet {
                guard self.enablePinchGesture != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(enablePinchGesture: self.enablePinchGesture)
                }
            }
        }
        public var contentInset: InsetFloat = .zero {
            didSet {
                guard self.contentInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(contentInset: self.contentInset)
                }
            }
        }
        public private(set) var contentSize: SizeFloat = .zero
        public var request: Request? {
            didSet {
                guard self.request != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(request: self.request)
                }
            }
        }
        public private(set) var state: State = .empty
        public var onAppear: ((UI.View.Web) -> Void)?
        public var onDisappear: ((UI.View.Web) -> Void)?
        public var onVisible: ((UI.View.Web) -> Void)?
        public var onVisibility: ((UI.View.Web) -> Void)?
        public var onInvisible: ((UI.View.Web) -> Void)?
        public var onContentSize: ((UI.View.Web) -> Void)?
        public var onBeginLoading: ((UI.View.Web) -> Void)?
        public var onEndLoading: ((UI.View.Web) -> Void)?
        public var onDecideNavigation: ((UI.View.Web, URLRequest) -> NavigationPolicy)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        
        public init() {
        }
        
        public convenience init(
            configure: (UI.View.Web) -> Void
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
        
    }
    
}

public extension UI.View.Web {
    
    var canGoBack: Bool {
        return self._view.canGoBack
    }
    
    var canGoForward: Bool {
        return self._view.canGoForward
    }
    
}

public extension UI.View.Web {
    
    @inlinable
    @discardableResult
    func enablePinchGesture(_ value: Bool) -> Self {
        self.enablePinchGesture = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func request(_ value: Request) -> Self {
        self.request = value
        return self
    }
    
    @discardableResult
    func goBack() -> Self {
        self._view.goBack()
        return self
    }
    
    @discardableResult
    func goForward() -> Self {
        self._view.goForward()
        return self
    }
    
}

public extension UI.View.Web {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onContentSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onBeginLoading = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading(_ value: ((UI.View.Web) -> Void)?) -> Self {
        self.onEndLoading = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ value: ((UI.View.Web, URLRequest) -> NavigationPolicy)?) -> Self {
        self.onDecideNavigation = value
        return self
    }
    
}

public extension UI.View.Web {
    
    func evaluate< Result >(
        javaScript: String,
        success: @escaping (Result) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self._view.evaluate(javaScript: javaScript, success: success, failure: failure)
    }
    
}

extension UI.View.Web : KKWebViewDelegate {
    
    func update(_ view: KKWebView, contentSize: SizeFloat) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            self.onContentSize?(self)
        }
    }
    
    func beginLoading(_ view: KKWebView) {
        self.state = .loading
        self.onBeginLoading?(self)
    }
    
    func endLoading(_ view: KKWebView, error: Error?) {
        self.state = .loaded(error)
        self.onEndLoading?(self)
    }
    
    func onDecideNavigation(_ view: KKWebView, request: URLRequest) -> NavigationPolicy {
        self.onDecideNavigation?(self, request) ?? .allow
    }
    
}

#endif
