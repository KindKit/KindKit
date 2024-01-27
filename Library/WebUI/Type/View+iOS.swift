//
//  KindKit
//

#if os(iOS)

import UIKit
import WebKit
import KindUI

extension View {
    
    struct Reusable : IReusable {
        
        typealias Owner = View
        typealias Content = KKWebView

        static var reuseIdentificator: String {
            return "View"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: UIScreen.main.bounds)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKWebView : WKWebView {
    
    unowned var kkDelegate: KKWebViewDelegate?
    var kkContentInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkContentInset != oldValue else { return }
            self.safeAreaInsetsDidChange()
        }
    }
    var kkEnablePinchGesture: Bool = true
    var kkCurrentNavigation: WKNavigation?
    
    override var safeAreaInsets: UIEdgeInsets {
        return self.kkContentInset
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        self.navigationDelegate = self
        self.uiDelegate = self
        self.clipsToBounds = true
        
        self.scrollView.contentInsetAdjustmentBehavior = .always
        self.scrollView.backgroundColor = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            self.kkDelegate?.update(self, contentSize: Size(self.scrollView.contentSize))
        }
    }
    
}

extension KKWebView {
    
    func update(view: View) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(contentInset: view.contentInset)
        self.update(enablePinchGesture: view.enablePinchGesture)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
        self.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.update(request: view.request)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(request: View.Request?) {
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
            self.kkDelegate?.beginLoading(self)
        } else {
            self.stopLoading()
        }
    }
    
    func update(contentInset: Inset) {
        self.kkContentInset = contentInset.uiEdgeInsets
    }
    
    func update(enablePinchGesture: Bool) {
        self.kkEnablePinchGesture = enablePinchGesture
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self.stopLoading()
        self.load(URLRequest(url: URL(string: "about:blank")!))
        self.frame = .zero
        self.scrollView.removeObserver(self, forKeyPath: "contentSize")
        self.frame = UIScreen.main.bounds
    }
    
    func evaluate< Result >(
        javaScript: String,
        success: @escaping (Result) -> Void,
        failure: @escaping (Swift.Error) -> Void
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
    
}

extension KKWebView : UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = self.kkEnablePinchGesture
    }
    
}

extension KKWebView : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let kkDelegate = self.kkDelegate else {
            decisionHandler(.allow)
            return
        }
        switch navigationAction.navigationType {
        case .linkActivated, .formSubmitted, .formResubmitted, .backForward, .reload:
            let navigationPolicy = kkDelegate.decideNavigation(self, request: navigationAction.request)
            switch navigationPolicy {
            case .cancel: decisionHandler(.cancel)
            case .allow: decisionHandler(.allow)
            }
        default:
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.kkCurrentNavigation = navigation
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard self.kkCurrentNavigation === navigation else {
            return
        }
        self.kkDelegate?.endLoading(self, error: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Swift.Error) {
        guard self.kkCurrentNavigation === navigation else {
            return
        }
        self.kkDelegate?.endLoading(self, error: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Swift.Error) {
        guard self.kkCurrentNavigation === navigation else {
            return
        }
        self.kkDelegate?.endLoading(self, error: error)
    }
    
}

extension KKWebView : WKUIDelegate {
}

#endif
