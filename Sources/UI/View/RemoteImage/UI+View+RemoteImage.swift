//
//  KindKit
//

import Foundation

public extension UI.View {

    final class RemoteImage : IUIWidgetView {
        
        public let body: UI.View.Custom
        public let loader: KindKit.RemoteImage.Loader = .shared
        public var query: IRemoteImageQuery?
        public var filter: IRemoteImageFilter?
        public var placeholder: IUIView? {
            didSet {
                guard self.placeholder !== oldValue else { return }
                self._layout.placeholder = self.placeholder
            }
        }
        public private(set) var imageView: IUIView? {
            didSet {
                guard self.imageView !== oldValue else { return }
                self._layout.image = self.imageView
            }
        }
        public var progress: (IUIView & IUIViewProgressable)? {
            didSet {
                guard self.progress !== oldValue else { return }
                self._layout.progress = self.progress
            }
        }
        public var error: IUIView? {
            didSet {
                guard self.error !== oldValue else { return }
                self._layout.error = self.error
            }
        }
        public private(set) var isLoading: Bool = false
        public let onProgress: Signal.Args< Void, Double > = .init()
        public let onFinish: Signal.Args< IUIView?, UI.Image > = .init()
        public let onError: Signal.Args< Void, KindKit.RemoteImage.Error > = .init()
        
        private var _layout: Layout
        
        public init() {
            self._layout = Layout()
            self.body = UI.View.Custom()
                .content(self._layout)
            self._setup()
        }
        
    }
    
}

private extension UI.View.RemoteImage {
    
    func _setup() {
        self.body
            .onAppear(self, { $0.startLoading() })
            .onDisappear(self, { $0.stopLoading() })
    }
    
    func _start() {
        if self.isLoading == false && self.imageView == nil {
            if let query = self.query {
                self.isLoading = true
                self._layout.state = .loading
                self.progress?.progress(0)
                self.loader.download(target: self, query: query, filter: self.filter)
            }
        }
    }

    func _stop() {
        if self.isLoading == true {
            self.isLoading = false
            self.loader.cancel(target: self)
        }
    }
    
}

public extension UI.View.RemoteImage {
    
    @discardableResult
    func startLoading() -> Self {
        self._start()
        return self
    }
    
    @discardableResult
    func stopLoading() -> Self {
        self._stop()
        return self
    }

}

public extension UI.View.RemoteImage {
    
    @inlinable
    @discardableResult
    func placeholder(_ value: IUIView) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progress(_ value: (IUIView & IUIViewProgressable)?) -> Self {
        self.progress = value
        return self
    }
    
    @inlinable
    @discardableResult
    func error(_ value: IUIView?) -> Self {
        self.error = value
        return self
    }
    
    @inlinable
    @discardableResult
    func query(_ value: IRemoteImageQuery) -> Self {
        self.query = value
        return self
    }
    
    @inlinable
    @discardableResult
    func filter(_ value: IRemoteImageFilter?) -> Self {
        self.filter = value
        return self
    }
    
}

public extension UI.View.RemoteImage {
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: (() -> Void)?) -> Self {
        self.onProgress.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: ((Self) -> Void)?) -> Self {
        self.onProgress.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: ((Double) -> Void)?) -> Self {
        self.onProgress.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: ((Self, Double) -> Void)?) -> Self {
        self.onProgress.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onProgress.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Double) -> Void)?) -> Self {
        self.onProgress.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: (() -> IUIView?)?) -> Self {
        self.onFinish.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((Self) -> IUIView?)?) -> Self {
        self.onFinish.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((UI.Image) -> IUIView?)?) -> Self {
        self.onFinish.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((Self, UI.Image) -> IUIView?)?) -> Self {
        self.onFinish.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> IUIView?)?) -> Self {
        self.onFinish.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, UI.Image) -> IUIView?)?) -> Self {
        self.onFinish.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: (() -> Void)?) -> Self {
        self.onError.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: ((Self) -> Void)?) -> Self {
        self.onError.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: ((KindKit.RemoteImage.Error) -> Void)?) -> Self {
        self.onError.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: ((Self, KindKit.RemoteImage.Error) -> Void)?) -> Self {
        self.onError.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onError.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, KindKit.RemoteImage.Error) -> Void)?) -> Self {
        self.onError.link(sender, closure)
        return self
    }
    
}

extension UI.View.RemoteImage : IUIViewReusable {
}

#if os(iOS)

extension UI.View.RemoteImage : IUIViewTransformable {
}

#endif

extension UI.View.RemoteImage : IUIViewDynamicSizeable {
}

extension UI.View.RemoteImage : IRemoteImageTarget {
    
    public func remoteImage(progress: Double) {
        self.progress?.progress(progress)
        self.onProgress.emit(progress)
    }
    
    public func remoteImage(image: UI.Image) {
        self.isLoading = false
        self._layout.state = .loaded
        self.imageView = self.onFinish.emit(image, default: UI.View.Image().image(image))
    }
    
    public func remoteImage(error: KindKit.RemoteImage.Error) {
        self.isLoading = false
        self._layout.state = .error
        self.onError.emit(error)
    }
    
}

public extension IUIView where Self == UI.View.RemoteImage {
    
    @inlinable
    static func remoteImage() -> Self {
        return .init()
    }
    
}
