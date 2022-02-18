//
//  KindKitView
//

#if os(iOS)

import UIKit
import WebKit
import KindKitCore
import KindKitMath

extension WebView {
    
    struct Reusable : IReusable {
        
        typealias Owner = WebView
        typealias Content = NativeWebView

        static var reuseIdentificator: String {
            return "WebView"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class NativeWebView : WKWebView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: WebViewDelegate?
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: View?
    private var _enablePinchGesture: Bool
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        self._enablePinchGesture = true
        
        super.init(frame: frame, configuration: configuration)

        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.clipsToBounds = true
        self.navigationDelegate = self
        self.uiDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            self.customDelegate?._update(contentSize: SizeFloat(self.scrollView.contentSize))
        }
    }
    
}

extension NativeWebView {
    
    func update(view: WebView) {
        self._view = view
        self.update(enablePinchGesture: view.enablePinchGesture)
        self.update(contentInset: view.contentInset)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
        self.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.update(request: view.request)
    }
    
    func update(enablePinchGesture: Bool) {
        self._enablePinchGesture = enablePinchGesture
    }
    
    func update(contentInset: InsetFloat) {
        self.scrollView.contentInset = contentInset.uiEdgeInsets
        self.scrollView.scrollIndicatorInsets = contentInset.uiEdgeInsets
    }
    
    func update(request: WebViewRequest?) {
        if let request = request {
            switch request {
            case .request(let request):
                self.load(request)
            case .file(let url, let readAccess):
                self.loadFileURL(url, allowingReadAccessTo: readAccess)
            case .html(let string, let baseUrl):
                self.loadHTMLString(string, baseURL: baseUrl)
            case .data(let data, let mimeType, let encoding, let baseUrl):
                self.load(data, mimeType: mimeType, characterEncodingName: encoding, baseURL: baseUrl)
            }
            self.customDelegate?._beginLoading()
        } else {
            self.stopLoading()
        }
    }
    
    func evaluate< Result >(
        javaScript: String,
        success: @escaping (Result) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self.evaluateJavaScript(javaScript, completionHandler: { result, error in
            if let result = result as? Result {
                success(result)
            } else if let error = error {
                failure(error)
            } else {
                failure(WKError(WKError.javaScriptResultTypeIsUnsupported))
            }
        })
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
        self.load(URLRequest(url: URL(string: "about:blank")!))
        self.frame = .zero
        self.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
}

extension NativeWebView : UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = self._enablePinchGesture
    }
    
}

extension NativeWebView : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.customDelegate?._endLoading(error: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.customDelegate?._endLoading(error: error)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let customDelegate = self.customDelegate else {
            decisionHandler(.allow)
            return
        }
        switch navigationAction.navigationType {
        case .linkActivated, .formSubmitted, .formResubmitted, .backForward, .reload:
            let navigationPolicy = customDelegate._onDecideNavigation(request: navigationAction.request)
            switch navigationPolicy {
            case .cancel: decisionHandler(.cancel)
            case .allow: decisionHandler(.allow)
            }
        default:
            decisionHandler(.allow)
        }
    }
    
}

extension NativeWebView : WKUIDelegate {
}

#endif
