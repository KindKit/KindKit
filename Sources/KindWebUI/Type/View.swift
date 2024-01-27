//
//  KindKit
//

import KindUI

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKWebViewDelegate : AnyObject {
    
    func update(_ view: KKWebView, contentSize: Size)
    
    func beginLoading(_ view: KKWebView)
    func endLoading(_ view: KKWebView, error: Swift.Error?)
    
    func decideNavigation(_ view: KKWebView, request: URLRequest) -> View.NavigationPolicy
    
}

public final class View {
    
    public private(set) weak var appearedLayout: Layout?
    public var frame: KindMath.Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(transform: self.transform)
            }
        }
    }
#endif
    public var size: StaticSize = .init(.fill, .fill) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
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
    public var color: KindGraphics.Color? {
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
            self.setNeedLayout()
        }
    }
    public private(set) var isVisible: Bool = false
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    public let onContentSize = Signal< Void, Void >()
    public let onBeginLoading = Signal< Void, Void >()
    public let onEndLoading = Signal< Void, Void >()
    public let onDecideNavigation = Signal< NavigationPolicy?, URLRequest >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension View {
    
    var canGoBack: Bool {
        return self._view.canGoBack
    }
    
    var canGoForward: Bool {
        return self._view.canGoForward
    }
    
}

public extension View {
    
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
        failure: @escaping (Swift.Error) -> Void
    ) {
        self._view.evaluate(javaScript: javaScript, success: success, failure: failure)
    }
    
}

public extension View {
    
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

public extension View {
    
    @inlinable
    @discardableResult
    func onContentSize(_ closure: @escaping () -> Void) -> Self {
        self.onContentSize.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize(_ closure: @escaping (Self) -> Void) -> Self {
        self.onContentSize.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onContentSize.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onContentSize(remove target: AnyObject) -> Self {
        self.onContentSize.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading(_ closure: @escaping () -> Void) -> Self {
        self.onBeginLoading.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginLoading.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onBeginLoading.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginLoading(remove target: AnyObject) -> Self {
        self.onBeginLoading.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading(_ closure: @escaping () -> Void) -> Self {
        self.onEndLoading.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndLoading.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onEndLoading.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndLoading(remove target: AnyObject) -> Self {
        self.onEndLoading.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: @escaping () -> NavigationPolicy?) -> Self {
        self.onDecideNavigation.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: @escaping (Self) -> NavigationPolicy?) -> Self {
        self.onDecideNavigation.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: @escaping (URLRequest) -> NavigationPolicy?) -> Self {
        self.onDecideNavigation.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(_ closure: @escaping (Self, URLRequest) -> NavigationPolicy?) -> Self {
        self.onDecideNavigation.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, URLRequest) -> NavigationPolicy?) -> Self {
        self.onDecideNavigation.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDecideNavigation(remove target: AnyObject) -> Self {
        self.onDecideNavigation.remove(target)
        return self
    }
    
}

extension View : IView {
    
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
        return self.size.apply(available: available)
    }
    
    public func appear(to layout: Layout) {
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
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension View : IViewReusable {
    
    public var reuseUnloadBehaviour: ReuseUnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: ReuseCache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension View : IViewSupportTransform {
}

#endif

extension View : IViewSupportStaticSize {
}

extension View : IViewSupportColor {
}

extension View : IViewSupportAlpha {
}

extension View : KKWebViewDelegate {
    
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
    
    func endLoading(_ view: KKWebView, error: Swift.Error?) {
        self.state = .loaded(error)
        self.onEndLoading.emit()
    }
    
    func decideNavigation(_ view: KKWebView, request: URLRequest) -> NavigationPolicy {
        return self.onDecideNavigation.emit(request, default: .allow)
    }
    
}

#endif
