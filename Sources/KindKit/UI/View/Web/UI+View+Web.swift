//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKWebViewDelegate : AnyObject {
    
    func update(_ view: KKWebView, contentSize: Size)
    
    func beginLoading(_ view: KKWebView)
    func endLoading(_ view: KKWebView, error: Error?)
    
    func decideNavigation(_ view: KKWebView, request: URLRequest) -> UI.View.Web.NavigationPolicy
    
}

public extension UI.View {

    final class Web {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Static = .init(.fill, .fill) {
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
        public private(set) var contentSize: Size = .zero
        public var contentInset: Inset = .zero {
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
        public var alpha: Double = 1 {
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
    
}

public extension UI.View.Web {
    
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
    
    @discardableResult
    func reload() -> Self {
        if self.isLoaded == true {
            self._view.update(request: self.request)
        }
        return self
    }
    
    func evaluate< Result >(
        javaScript: String,
        success: @escaping (Result) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self._view.evaluate(javaScript: javaScript, success: success, failure: failure)
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
    func request(_ value: () -> Request) -> Self {
        return self.request(value())
    }

    @inlinable
    @discardableResult
    func request(_ value: (Self) -> Request) -> Self {
        return self.request(value(self))
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: () -> Inset) -> Self {
        return self.contentInset(value())
    }

    @inlinable
    @discardableResult
    func contentInset(_ value: (Self) -> Inset) -> Self {
        return self.contentInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func enablePinchGesture(_ value: Bool) -> Self {
        self.enablePinchGesture = value
        return self
    }
    
    @inlinable
    @discardableResult
    func enablePinchGesture(_ value: () -> Bool) -> Self {
        return self.enablePinchGesture(value())
    }

    @inlinable
    @discardableResult
    func enablePinchGesture(_ value: (Self) -> Bool) -> Self {
        return self.enablePinchGesture(value(self))
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
    func onContentSize(_ closure: @escaping (Self) -> Void) -> Self {
        self.onContentSize.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
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
    func onBeginLoading(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginLoading.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
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
    func onEndLoading(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndLoading.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
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
    func onDecideNavigation(_ closure: @escaping (Self) -> NavigationPolicy?) -> Self {
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
    func onDecideNavigation(_ closure: @escaping (Self, URLRequest) -> NavigationPolicy?) -> Self {
        self.onDecideNavigation.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, URLRequest) -> NavigationPolicy?) -> Self {
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
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
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

#if os(iOS)

extension UI.View.Web : IUIViewTransformable {
}

#endif

extension UI.View.Web : IUIViewStaticSizeable {
}

extension UI.View.Web : IUIViewColorable {
}

extension UI.View.Web : IUIViewAlphable {
}

extension UI.View.Web : KKWebViewDelegate {
    
    func update(_ view: KKWebView, contentSize: Size) {
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

public extension IUIView where Self == UI.View.Web {
    
    @inlinable
    static func web(_ request: UI.View.Web.Request) -> Self {
        return .init().request(request)
    }
    
}

#endif
