//
//  KindKit
//

import Foundation

public extension UI.View {

    final class RemoteImage : IUIWidgetView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public let body: UI.View.Custom
        public var placeholder: UI.View.Image? {
            didSet {
                guard self.placeholder !== oldValue else { return }
                self._layout.placeholder = self.placeholder.flatMap({ UI.Layout.Item($0) })
            }
        }
        public private(set) var imageView: UI.View.Image? {
            didSet {
                guard self.imageView !== oldValue else { return }
                self._layout.image = self.imageView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var progress: (IUIView & IUIViewProgressable)? {
            didSet {
                guard self.progress !== oldValue else { return }
                self._layout.progress = self.progress.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var error: IUIView? {
            didSet {
                guard self.error !== oldValue else { return }
                self._layout.error = self.error.flatMap({ UI.Layout.Item($0) })
            }
        }
        public private(set) var isLoading: Bool = false
        public let loader: KindKit.RemoteImage.Loader
        public var query: IRemoteImageQuery
        public var filter: IRemoteImageFilter?
        public let onProgress: Signal.Args< Void, Float > = .init()
        public let onFinish: Signal.Args< UI.View.Image?, UI.Image > = .init()
        public let onError: Signal.Args< Void, Error > = .init()
        
        private var _layout: Layout
        
        public init(
            loader: KindKit.RemoteImage.Loader = .shared,
            query: IRemoteImageQuery,
            filter: IRemoteImageFilter? = nil
        ) {
            self.loader = loader
            self.query = query
            self.filter = filter
            self._layout = Layout()
            self.body = UI.View.Custom(self._layout)
        }
        
        public convenience init(
            loader: KindKit.RemoteImage.Loader = .shared,
            query: IRemoteImageQuery,
            filter: IRemoteImageFilter? = nil,
            configure: (UI.View.RemoteImage) -> Void
        ) {
            self.init(loader: loader, query: query, filter: filter)
            self.modify(configure)
        }
        
        @discardableResult
        public func startLoading() -> Self {
            self._start()
            return self
        }
        
        @discardableResult
        public func stopLoading() -> Self {
            self._stop()
            return self
        }
        
    }
    
}

private extension UI.View.RemoteImage {
    
    func _setup() {
        self.body
            .onAppear(self, { $0.startLoading() })
            .onDisappear(self, { $0.stopLoading() })
    }
    
}

public extension UI.View.RemoteImage {
    
    @inlinable
    @discardableResult
    func placeholder(_ value: UI.View.Image) -> Self {
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
        self.onProgress.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: ((Self) -> Void)?) -> Self {
        self.onProgress.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: ((Float) -> Void)?) -> Self {
        self.onProgress.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: ((Self, Float) -> Void)?) -> Self {
        self.onProgress.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onProgress.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Float) -> Void)?) -> Self {
        self.onProgress.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: (() -> UI.View.Image?)?) -> Self {
        self.onFinish.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((Self) -> UI.View.Image?)?) -> Self {
        self.onFinish.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((UI.Image) -> UI.View.Image?)?) -> Self {
        self.onFinish.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((Self, UI.Image) -> UI.View.Image?)?) -> Self {
        self.onFinish.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> UI.View.Image?)?) -> Self {
        self.onFinish.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, UI.Image) -> UI.View.Image?)?) -> Self {
        self.onFinish.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: (() -> Void)?) -> Self {
        self.onError.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: ((Self) -> Void)?) -> Self {
        self.onError.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: ((Error) -> Void)?) -> Self {
        self.onError.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: ((Self, Error) -> Void)?) -> Self {
        self.onError.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onError.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Error) -> Void)?) -> Self {
        self.onError.set(sender, closure)
        return self
    }
    
}

private extension UI.View.RemoteImage {
    
    func _start() {
        if self.isLoading == false && self.imageView == nil {
            self.isLoading = true
            self._layout.state = .loading
            self.progress?.progress(0)
            if let filter = self.filter {
                self.loader.download(target: self, query: self.query, filter: filter)
            } else {
                self.loader.download(target: self, query: self.query)
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

extension UI.View.RemoteImage : IRemoteImageTarget {
    
    public func remoteImage(progress: Float) {
        self.progress?.progress(progress)
        self.onProgress.emit(progress)
    }
    
    public func remoteImage(image: UI.Image) {
        self.isLoading = false
        self._layout.state = .loaded
        self.imageView = self.onFinish.emit(image, default: UI.View.Image(image))
    }
    
    public func remoteImage(error: Error) {
        self.isLoading = false
        self._layout.state = .error
        self.onError.emit(error)
    }
    
}
