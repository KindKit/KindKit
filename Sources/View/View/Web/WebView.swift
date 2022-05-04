//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

protocol WebViewDelegate : AnyObject {
    
    func _update(contentSize: SizeFloat)
    
    func _beginLoading()
    func _endLoading(error: Error?)
    
    func _onDecideNavigation(request: URLRequest) -> WebViewNavigationPolicy
    
}

public class WebView : IWebView {
    
    public private(set) unowned var layout: ILayout?
    public unowned var item: LayoutItem?
    public var native: NativeView {
        return self._view
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return RectFloat(self._view.bounds)
    }
    public private(set) var isVisible: Bool
    public var isHidden: Bool {
        didSet(oldValue) {
            guard self.isHidden != oldValue else { return }
            self.setNeedForceLayout()
        }
    }
    public var width: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var enablePinchGesture: Bool {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(enablePinchGesture: self.enablePinchGesture)
        }
    }
    public var contentInset: InsetFloat {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(contentInset: self.contentInset)
        }
    }
    public private(set) var contentSize: SizeFloat
    public var request: WebViewRequest? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(request: request)
        }
    }
    public private(set) var state: WebViewState
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
            self._view.updateShadowPath()
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
            self._view.updateShadowPath()
        }
    }
    public var alpha: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onContentSize: (() -> Void)?
    private var _onBeginLoading: (() -> Void)?
    private var _onEndLoading: (() -> Void)?
    private var _onDecideNavigation: ((_ request: URLRequest) -> WebViewNavigationPolicy)?
    
    public init(
        reuseBehaviour: ReuseItemBehaviour = .unloadWhenDestroy,
        width: StaticSizeBehaviour,
        height: StaticSizeBehaviour,
        enablePinchGesture: Bool = true,
        contentInset: InsetFloat = .zero,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.enablePinchGesture = enablePinchGesture
        self.contentInset = contentInset
        self.contentSize = .zero
        self.state = .empty
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem(behaviour: reuseBehaviour)
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
        return StaticSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height
        )
    }
    
    public func appear(to layout: ILayout) {
        self.layout = layout
        self._onAppear?()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.layout = nil
        self._onDisappear?()
    }
    
    public func visible() {
        self.isVisible = true
        self._onVisible?()
    }
    
    public func visibility() {
        self._onVisibility?()
    }
    
    public func invisible() {
        self.isVisible = false
        self._onInvisible?()
    }
    
    public func evaluate< Result >(
        javaScript: String,
        success: @escaping (Result) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self._view.evaluate(javaScript: javaScript, success: success, failure: failure)
    }
    
    @discardableResult
    public func width(_ value: StaticSizeBehaviour) -> Self {
        self.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: StaticSizeBehaviour) -> Self {
        self.height = value
        return self
    }
    
    @discardableResult
    public func enablePinchGesture(_ value: Bool) -> Self {
        self.enablePinchGesture = value
        return self
    }
    
    @discardableResult
    public func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
    @discardableResult
    public func request(_ value: WebViewRequest) -> Self {
        self.request = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self.border = value
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self.shadow = value
        return self
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._onAppear = value
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._onDisappear = value
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._onVisible = value
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._onVisibility = value
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._onInvisible = value
        return self
    }
    
    @discardableResult
    public func onContentSize(_ value: (() -> Void)?) -> Self {
        self._onContentSize = value
        return self
    }
    
    @discardableResult
    public func onBeginLoading(_ value: (() -> Void)?) -> Self {
        self._onBeginLoading = value
        return self
    }
    
    @discardableResult
    public func onEndLoading(_ value: (() -> Void)?) -> Self {
        self._onEndLoading = value
        return self
    }
    
    @discardableResult
    public func onDecideNavigation(_ value: ((_ request: URLRequest) -> WebViewNavigationPolicy)?) -> Self {
        self._onDecideNavigation = value
        return self
    }
    
}

extension WebView : WebViewDelegate {
    
    func _update(contentSize: SizeFloat) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            self._onContentSize?()
        }
    }
    
    func _beginLoading() {
        self.state = .loading
        self._onBeginLoading?()
    }
    
    func _endLoading(error: Error?) {
        self.state = .loaded(error)
        self._onEndLoading?()
    }
    
    func _onDecideNavigation(request: URLRequest) -> WebViewNavigationPolicy {
        self._onDecideNavigation?(request) ?? .allow
    }
    
}
