//
//  KindKit
//

import Foundation

public extension UI.View {

    final class RemoteImage : IUIWidgetView, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) var isLoading: Bool = false
        public var placeholderView: UI.View.Image? {
            didSet(oldValue) {
                guard self.placeholderView !== oldValue else { return }
                self._layout.placeholderItem = self.placeholderView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public private(set) var imageView: UI.View.Image? {
            didSet(oldValue) {
                guard self.imageView !== oldValue else { return }
                self._layout.imageItem = self.imageView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var progressView: (IUIView & IUIViewProgressable)? {
            didSet(oldValue) {
                guard self.progressView !== oldValue else { return }
                self._layout.progressItem = self.progressView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var errorView: IUIView? {
            didSet(oldValue) {
                guard self.errorView !== oldValue else { return }
                self._layout.errorItem = self.errorView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public private(set) var loader: KindKit.RemoteImage.Loader
        public var query: IRemoteImageQuery
        public var filter: IRemoteImageFilter?
        public private(set) var body: UI.View.Custom
        
        private var _layout: Layout
        private var _onProgress: ((UI.View.RemoteImage, Float) -> Void)?
        private var _onFinish: ((UI.View.RemoteImage, KindKit.Image) -> UI.View.Image)?
        private var _onError: ((UI.View.RemoteImage, Error) -> Void)?
        
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
            self.body.onAppear({ [unowned self] _ in self.startLoading() })
            self.body.onDisappear({ [unowned self] _ in self.stopLoading() })
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
        
        @discardableResult
        public func onProgress(_ value: ((UI.View.RemoteImage, Float) -> Void)?) -> Self {
            self._onProgress = value
            return self
        }
        
        @discardableResult
        public func onFinish(_ value: ((UI.View.RemoteImage, KindKit.Image) -> UI.View.Image)?) -> Self {
            self._onFinish = value
            return self
        }
        
        @discardableResult
        public func onError(_ value: ((UI.View.RemoteImage, Error) -> Void)?) -> Self {
            self._onError = value
            return self
        }
        
    }
    
}

public extension UI.View.RemoteImage {
    
    @inlinable
    @discardableResult
    func placeholderView(_ value: UI.View.Image) -> Self {
        self.placeholderView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progressView(_ value: (IUIView & IUIViewProgressable)?) -> Self {
        self.progressView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func errorView(_ value: IUIView?) -> Self {
        self.errorView = value
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

private extension UI.View.RemoteImage {
    
    func _start() {
        if self.isLoading == false && self.imageView == nil {
            self.isLoading = true
            self._layout.state = .loading
            self.progressView?.progress(0)
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

private extension UI.View.RemoteImage {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State = .loading {
            didSet(oldValue) {
                guard self.state != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        var placeholderItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.placeholderItem) }
        }
        var imageItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.imageItem) }
        }
        var progressItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.progressItem) }
        }
        var errorItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.errorItem) }
        }

        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .loading:
                let placeholderSize: SizeFloat
                if let placeholderItem = self.placeholderItem {
                    placeholderSize = placeholderItem.size(available: bounds.size)
                    placeholderItem.frame = RectFloat(center: bounds.center, size: placeholderSize)
                } else {
                    placeholderSize = .zero
                }
                if let progressItem = self.progressItem {
                    let progressSize = progressItem.size(available: bounds.size)
                    progressItem.frame = RectFloat(center: bounds.center, size: progressSize)
                    return Size(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                if let imageItem = self.imageItem {
                    let imageSize = imageItem.size(available: bounds.size)
                    imageItem.frame = RectFloat(center: bounds.center, size: imageSize)
                    return imageSize
                } else if let placeholderItem = self.placeholderItem {
                    let placeholderSize = placeholderItem.size(available: bounds.size)
                    placeholderItem.frame = RectFloat(center: bounds.center, size: placeholderSize)
                    return placeholderSize
                }
                return .zero
            case .error:
                if let errorItem = self.errorItem {
                    let errorSize = errorItem.size(available: bounds.size)
                    errorItem.frame = RectFloat(center: bounds.center, size: errorSize)
                    return errorSize
                } else if let placeholderItem = self.placeholderItem {
                    let placeholderSize = placeholderItem.size(available: bounds.size)
                    placeholderItem.frame = RectFloat(center: bounds.center, size: placeholderSize)
                    return placeholderSize
                }
                return .zero
            }
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            switch self.state {
            case .loading:
                let placeholderSize: SizeFloat
                if let placeholderItem = self.placeholderItem {
                    placeholderSize = placeholderItem.size(available: available)
                } else {
                    placeholderSize = .zero
                }
                if let progressItem = self.progressItem {
                    let progressSize = progressItem.size(available: available)
                    return Size(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                if let imageItem = self.imageItem {
                    return imageItem.size(available: available)
                } else if let placeholderItem = self.placeholderItem {
                    return placeholderItem.size(available: available)
                }
                return .zero
            case .error:
                if let errorItem = self.errorItem {
                    return errorItem.size(available: available)
                } else if let placeholderItem = self.placeholderItem {
                    return placeholderItem.size(available: available)
                }
                return .zero
            }
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self.state {
            case .loading:
                if let placeholderItem = self.placeholderItem {
                    if let progressItem = self.progressItem {
                        return [ placeholderItem, progressItem ]
                    }
                } else if let progressItem = self.progressItem {
                    return [ progressItem ]
                }

            case .loaded:
                if let imageItem = self.imageItem {
                    return [ imageItem ]
                }
                if let placeholderItem = self.placeholderItem {
                    return [ placeholderItem ]
                }
            case .error:
                if let errorItem = self.errorItem {
                    return [ errorItem ]
                }
            }
            if let placeholderItem = self.placeholderItem {
                return [ placeholderItem ]
            }
            return []
        }
        
    }
    
}

private extension UI.View.RemoteImage.Layout {
    
    enum State {
        case loading
        case loaded
        case error
    }
    
}

extension UI.View.RemoteImage : IRemoteImageTarget {
    
    public func remoteImage(progress: Float) {
        self.progressView?.progress(progress)
        self._onProgress?(self, progress)
    }
    
    public func remoteImage(image: Image) {
        self.isLoading = false
        self._layout.state = .loaded
        
        let imageView: UI.View.Image
        if let onFinish = self._onFinish {
            imageView = onFinish(self, image)
        } else {
            imageView = UI.View.Image(image)
        }
        self.imageView = imageView
    }
    
    public func remoteImage(error: Error) {
        self.isLoading = false
        self._layout.state = .error
        self._onError?(self, error)
    }
    
}
