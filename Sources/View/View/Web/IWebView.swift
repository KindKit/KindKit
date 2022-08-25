//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum WebViewRequest {
    
    case request(_ request: URLRequest)
    case file(url: URL, readAccess: URL)
    case html(string: String, baseUrl: URL?)
    case data(data: Data, mimeType: String, encoding: String, baseUrl: URL)
        
}

public enum WebViewState {
    
    case empty
    case loading
    case loaded(_ error: Error?)
    
}

extension WebViewState : Equatable {
    
    public static func == (lhs: WebViewState, rhs: WebViewState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.loading, .loading): return true
        case (.loaded, .loaded): return true
        default: return false
        }
    }
    
}

public enum WebViewNavigationPolicy {

    case cancel
    case allow
    
}

public protocol IWebView : IView, IViewStaticSizeBehavioural, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var enablePinchGesture: Bool { set get }
    
    var contentInset: InsetFloat { set get }
    
    var contentSize: SizeFloat { get }
    
    var request: WebViewRequest? { set get }
    
    var state: WebViewState { get }
    
    func evaluate< Result >(javaScript: String, success: @escaping (Result) -> Void, failure: @escaping (Error) -> Void)
    
    @discardableResult
    func onContentSize(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onBeginLoading(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEndLoading(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onDecideNavigation(_ value: ((_ request: URLRequest) -> WebViewNavigationPolicy)?) -> Self

}

public extension IWebView {
    
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
    func request(_ value: WebViewRequest) -> Self {
        self.request = value
        return self
    }
    
}
