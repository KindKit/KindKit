//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitView
import KindKitMath

public final class RemoteImageView : IRemoteImageView {
    
    public var layout: ILayout? {
        get { return self._view.layout }
    }
    public unowned var item: LayoutItem? {
        set(value) { self._view.item = value }
        get { return self._view.item }
    }
    public var native: NativeView {
        return self._view.native
    }
    public var isLoaded: Bool {
        return self._view.isLoaded
    }
    public var bounds: RectFloat {
        return self._view.bounds
    }
    public var isVisible: Bool {
        return self._view.isVisible
    }
    public var isHidden: Bool {
        set(value) { self._view.isHidden = value }
        get { return self._view.isHidden }
    }
    public private(set) var isLoading: Bool
    public var placeholderView: IImageView {
        didSet(oldValue) {
            guard self.placeholderView !== oldValue else { return }
            self._layout.placeholderItem = LayoutItem(view: self.placeholderView)
        }
    }
    public private(set) var imageView: IImageView? {
        didSet(oldValue) {
            guard self.imageView !== oldValue else { return }
            self._layout.imageItem = self.imageView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public var progressView: IProgressView? {
        didSet(oldValue) {
            guard self.progressView !== oldValue else { return }
            self._layout.progressItem = self.progressView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public var errorView: IView? {
        didSet(oldValue) {
            guard self.errorView !== oldValue else { return }
            self._layout.errorItem = self.errorView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public private(set) var loader: RemoteImage.Loader
    public var query: IRemoteImageQuery
    public var filter: IRemoteImageFilter?
    public var color: Color? {
        set(value) { self._view.color = value }
        get { return self._view.color }
    }
    public var border: ViewBorder {
        set(value) { self._view.border = value }
        get { return self._view.border }
    }
    public var cornerRadius: ViewCornerRadius {
        set(value) { self._view.cornerRadius = value }
        get { return self._view.cornerRadius }
    }
    public var shadow: ViewShadow? {
        set(value) { self._view.shadow = value }
        get { return self._view.shadow }
    }
    public var alpha: Float {
        set(value) { self._view.alpha = value }
        get { return self._view.alpha }
    }
    
    private var _layout: Layout
    private var _view: CustomView< Layout >
    private var _onProgress: ((_ progress: Float) -> Void)?
    private var _onFinish: ((_ image: Image) -> IImageView)?
    private var _onError: ((_ error: Error) -> Void)?
    
    public init(
        placeholderView: IImageView,
        progressView: IProgressView? = nil,
        errorView: IView? = nil,
        loader: RemoteImage.Loader = RemoteImage.Loader.shared,
        query: IRemoteImageQuery,
        filter: IRemoteImageFilter? = nil,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1
    ) {
        self.isLoading = false
        self.placeholderView = placeholderView
        self.progressView = progressView
        self.loader = loader
        self.query = query
        self.filter = filter
        self._layout = Layout(
            state: .loading,
            placeholderItem: LayoutItem(view: placeholderView),
            progressItem: progressView.flatMap({ LayoutItem(view: $0) }),
            errorItem: errorView.flatMap({ LayoutItem(view: $0) })
        )
        self._view = CustomView(
            contentLayout: self._layout,
            color: color,
            border: border,
            cornerRadius: cornerRadius,
            shadow: shadow,
            alpha: alpha
        )
    }
    
    public func loadIfNeeded() {
        self._view.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self._view.size(available: available)
    }
    
    public func appear(to layout: ILayout) {
        self._view.appear(to: layout)
    }
    
    public func disappear() {
        self._view.disappear()
    }
    
    public func visible() {
        self._view.visible()
    }
    
    public func visibility() {
        self._view.visibility()
    }
    
    public func invisible() {
        self._view.invisible()
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
    public func placeholderView(_ value: IImageView) -> Self {
        self.placeholderView = value
        return self
    }
    
    @discardableResult
    public func progressView(_ value: IProgressView?) -> Self {
        self.progressView = value
        return self
    }
    
    @discardableResult
    public func errorView(_ value: IView?) -> Self {
        self.errorView = value
        return self
    }
    
    @discardableResult
    public func query(_ value: IRemoteImageQuery) -> Self {
        self.query = value
        return self
    }
    
    @discardableResult
    public func filter(_ value: IRemoteImageFilter?) -> Self {
        self.filter = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self._view.color(value)
        return self
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self._view.border(value)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self._view.cornerRadius(value)
        return self
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self._view.shadow(value)
        return self
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self._view.alpha(value)
        return self
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self._view.hidden(value)
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._view.onAppear(value)
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._view.onDisappear(value)
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._view.onVisibility(value)
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._view.onVisible(value)
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._view.onInvisible(value)
        return self
    }
    
    @discardableResult
    public func onProgress(_ value: ((_ progress: Float) -> Void)?) -> Self {
        self._onProgress = value
        return self
    }
    
    @discardableResult
    public func onFinish(_ value: ((_ image: Image) -> IImageView)?) -> Self {
        self._onFinish = value
        return self
    }
    
    @discardableResult
    public func onError(_ value: ((_ error: Error) -> Void)?) -> Self {
        self._onError = value
        return self
    }
    
}

private extension RemoteImageView {
    
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

private extension RemoteImageView {
    
    final class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var state: State {
            didSet(oldValue) {
                guard self.state != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        var placeholderItem: LayoutItem {
            didSet { self.setNeedForceUpdate(item: self.placeholderItem) }
        }
        var imageItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.imageItem) }
        }
        var progressItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.progressItem) }
        }
        var errorItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.errorItem) }
        }

        init(
            state: State,
            placeholderItem: LayoutItem,
            progressItem: LayoutItem?,
            errorItem: LayoutItem?
        ) {
            self.state = state
            self.placeholderItem = placeholderItem
            self.progressItem = progressItem
            self.errorItem = errorItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .loading:
                let placeholderSize = self.placeholderItem.size(available: bounds.size)
                self.placeholderItem.frame = RectFloat(
                    center: bounds.center,
                    size: placeholderSize
                )
                if let progressItem = self.progressItem {
                    let progressSize = progressItem.size(available: bounds.size)
                    progressItem.frame = RectFloat(
                        center: self.placeholderItem.frame.center,
                        size: progressSize
                    )
                    return SizeFloat(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                let size: SizeFloat
                if let imageItem = self.imageItem {
                    size = imageItem.size(available: bounds.size)
                    imageItem.frame = RectFloat(
                        x: bounds.origin.x,
                        y: bounds.origin.y,
                        width: size.width,
                        height: size.height
                    )
                } else {
                    size = self.placeholderItem.size(available: bounds.size)
                    self.placeholderItem.frame = RectFloat(
                        x: bounds.origin.x,
                        y: bounds.origin.y,
                        width: size.width,
                        height: size.height
                    )
                }
                return size
            case .error:
                if let errorItem = self.errorItem {
                    let errorSize = errorItem.size(available: bounds.size)
                    errorItem.frame = RectFloat(
                        x: bounds.origin.x,
                        y: bounds.origin.y,
                        width: errorSize.width,
                        height: errorSize.height
                    )
                    return errorSize
                }
                let placeholderSize = self.placeholderItem.size(available: bounds.size)
                self.placeholderItem.frame = RectFloat(
                    x: bounds.origin.x,
                    y: bounds.origin.y,
                    width: placeholderSize.width,
                    height: placeholderSize.height
                )
                return placeholderSize
            }
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            switch self.state {
            case .loading:
                let placeholderSize = self.placeholderItem.size(available: available)
                if let progressItem = self.progressItem {
                    let progressSize = progressItem.size(available: available)
                    return SizeFloat(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                let size: SizeFloat
                if let imageItem = self.imageItem {
                    size = imageItem.size(available: available)
                } else {
                    size = self.placeholderItem.size(available: available)
                }
                return size
            case .error:
                if let errorItem = self.errorItem {
                    return errorItem.size(available: available)
                }
                return self.placeholderItem.size(available: available)
            }
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            switch self.state {
            case .loading:
                if let progressItem = self.progressItem {
                    return [ self.placeholderItem, progressItem ]
                }
                return [ self.placeholderItem ]
            case .loaded:
                if let imageItem = self.imageItem {
                    return [ imageItem ]
                }
                return [ self.placeholderItem ]
            case .error:
                if let errorItem = self.errorItem {
                    return [ errorItem ]
                }
                return [ self.placeholderItem ]
            }
        }
        
    }
    
}

private extension RemoteImageView.Layout {
    
    enum State {
        case loading
        case loaded
        case error
    }
    
}

extension RemoteImageView : IRemoteImageTarget {
    
    public func remoteImage(progress: Float) {
        self.progressView?.progress(progress)
        self._onProgress?(progress)
    }
    
    public func remoteImage(image: Image) {
        self.isLoading = false
        self._layout.state = .loaded
        
        let imageView: IImageView
        if let onFinish = self._onFinish {
            imageView = onFinish(image)
        } else {
            imageView = ImageView(image: image)
        }
        self.imageView = imageView
    }
    
    public func remoteImage(error: Error) {
        self.isLoading = false
        self._layout.state = .error
        self._onError?(error)
    }
    
}
