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

    final class Web : IUIView, IUIViewStaticSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var height: UI.Size.Static = .fill {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var enablePinchGesture: Bool = true {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(enablePinchGesture: self.enablePinchGesture)
            }
        }
        public var contentInset: InsetFloat = .zero {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(contentInset: self.contentInset)
            }
        }
        public private(set) var contentSize: SizeFloat = .zero
        public var request: Request? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(request: request)
            }
        }
        public private(set) var state: State = .empty
        public var color: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
                self._view.updateShadowPath()
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
                self._view.updateShadowPath()
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
        private var _onAppear: ((UI.View.Web) -> Void)?
        private var _onDisappear: ((UI.View.Web) -> Void)?
        private var _onVisible: ((UI.View.Web) -> Void)?
        private var _onVisibility: ((UI.View.Web) -> Void)?
        private var _onInvisible: ((UI.View.Web) -> Void)?
        private var _onContentSize: ((UI.View.Web) -> Void)?
        private var _onBeginLoading: ((UI.View.Web) -> Void)?
        private var _onEndLoading: ((UI.View.Web) -> Void)?
        private var _onDecideNavigation: ((UI.View.Web, URLRequest) -> NavigationPolicy)?
        
        public init() {
            self._reuse = UI.Reuse.Item(unloadBehaviour: .whenDestroy)
            self._reuse.configure(owner: self)
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
        
        public func evaluate< Result >(
            javaScript: String,
            success: @escaping (Result) -> Void,
            failure: @escaping (Error) -> Void
        ) {
            self._view.evaluate(javaScript: javaScript, success: success, failure: failure)
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onContentSize(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onContentSize = value
            return self
        }
        
        @discardableResult
        public func onBeginLoading(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onBeginLoading = value
            return self
        }
        
        @discardableResult
        public func onEndLoading(_ value: ((UI.View.Web) -> Void)?) -> Self {
            self._onEndLoading = value
            return self
        }
        
        @discardableResult
        public func onDecideNavigation(_ value: ((UI.View.Web, URLRequest) -> NavigationPolicy)?) -> Self {
            self._onDecideNavigation = value
            return self
        }
        
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
    
}

extension UI.View.Web : KKWebViewDelegate {
    
    func update(_ view: KKWebView, contentSize: SizeFloat) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            self._onContentSize?(self)
        }
    }
    
    func beginLoading(_ view: KKWebView) {
        self.state = .loading
        self._onBeginLoading?(self)
    }
    
    func endLoading(_ view: KKWebView, error: Error?) {
        self.state = .loaded(error)
        self._onEndLoading?(self)
    }
    
    func onDecideNavigation(_ view: KKWebView, request: URLRequest) -> NavigationPolicy {
        self._onDecideNavigation?(self, request) ?? .allow
    }
    
}

#endif
