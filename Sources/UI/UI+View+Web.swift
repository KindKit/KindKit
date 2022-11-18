//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKWebViewDelegate : AnyObject {
    
    func update(_ view: KKWebView, contentSize: SizeFloat)
    
    func beginLoading(_ view: KKWebView)
    func endLoading(_ view: KKWebView, error: Error?)
    
    func decideNavigation(_ view: KKWebView, request: URLRequest) -> UI.View.Web.NavigationPolicy
    
}

public extension UI.View {

    final class Web {
        
        public private(set) weak var appearedLayout: IUILayout?
        public weak var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Static = .init(width: .fill, height: .fill) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var request: Request? {
            didSet {
                guard self.request != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(request: self.request)
                }
            }
        }
        public private(set) var state: State = .empty
        public private(set) var contentSize: SizeFloat = .zero
        public var contentInset: InsetFloat = .zero {
            didSet {
                guard self.contentInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(contentInset: self.contentInset)
                }
            }
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
        public var enablePinchGesture: Bool = true {
            didSet {
                guard self.enablePinchGesture != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(enablePinchGesture: self.enablePinchGesture)
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
        public let onContentSize: Signal.Empty< Void > = .init()
        public let onBeginLoading: Signal.Empty< Void > = .init()
        public let onEndLoading: Signal.Empty< Void > = .init()
        public let onDecideNavigation: Signal.Args< NavigationPolicy?, URLRequest > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        @inlinable
        public convenience init(
            configure: (UI.View.Web) -> Void
        ) {
            self.init()
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
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
    
    func evaluate< Result >(
        javaScript: String,
        success: @escaping (Result) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self._view.evaluate(javaScript: javaScript, success: success, failure: failure)
    }
    
    func reload() {
        if self.isLoaded == true {
            self._view.update(request: self.request)
        }
    }
    
}

public extension UI.View.Web {
    
    @inlinable
    @discardableResult
    func request(_ value: Request) -> Self {
        self.request = value
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
    func enablePinchGesture(_ value: Bool) -> Self {
        self.enablePinchGesture = value
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
    func onContentSize(_ closure: (() -> Void)?) -> Self {
        self.onContentSize.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize(_ closure: ((Self) -> Void)?) -> Self {
        self.onContentSize.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onContentSize.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading(_ closure: (() -> Void)?) -> Self {
        self.onBeginLoading.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading(_ closure: ((Self) -> Void)?) -> Self {
        self.onBeginLoading.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onBeginLoading.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading(_ closure: (() -> Void)?) -> Self {
        self.onEndLoading.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading(_ closure: ((Self) -> Void)?) -> Self {
        self.onEndLoading.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onEndLoading.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: (() -> NavigationPolicy?)?) -> Self {
        self.onDecideNavigation.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: ((Self) -> NavigationPolicy?)?) -> Self {
        self.onDecideNavigation.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: ((URLRequest) -> NavigationPolicy?)?) -> Self {
        self.onDecideNavigation.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: ((Self, URLRequest) -> NavigationPolicy?)?) -> Self {
        self.onDecideNavigation.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, URLRequest) -> NavigationPolicy?)?) -> Self {
        self.onDecideNavigation.link(sender, closure)
        return self
    }
    
}

extension UI.View.Web : IUIView {
    
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

extension UI.View.Web : IUIViewReusable {
    
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

extension UI.View.Web : IUIViewStaticSizeable {
}

extension UI.View.Web : IUIViewColorable {
}

extension UI.View.Web : IUIViewAlphable {
}

extension UI.View.Web : KKWebViewDelegate {
    
    func update(_ view: KKWebView, contentSize: SizeFloat) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            self.onContentSize.emit()
        }
    }
    
    func beginLoading(_ view: KKWebView) {
        self.state = .loading
        self.onBeginLoading.emit()
    }
    
    func endLoading(_ view: KKWebView, error: Error?) {
        self.state = .loaded(error)
        self.onEndLoading.emit()
    }
    
    func decideNavigation(_ view: KKWebView, request: URLRequest) -> NavigationPolicy {
        return self.onDecideNavigation.emit(request, default: .allow)
    }
    
}

#endif
