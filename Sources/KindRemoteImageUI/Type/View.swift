//
//  KindKit
//

import KindRemoteImage
import KindUI
import KindMonadicMacro

@KindMonadic
public final class View : IWidgetView {
    
    public let body: KindUI.CustomView
    
    public let loader: KindRemoteImage.Loader = .shared
    
    @KindMonadicProperty
    public var query: KindRemoteImage.IQuery?
    
    @KindMonadicProperty
    public var filter: KindRemoteImage.IFilter?
    
    @KindMonadicProperty
    public var placeholder: IView? {
        didSet {
            guard self.placeholder !== oldValue else { return }
            self._layout.placeholder = self.placeholder
        }
    }
    
    @KindMonadicProperty
    public private(set) var imageView: IView? {
        didSet {
            guard self.imageView !== oldValue else { return }
            self._layout.image = self.imageView
        }
    }
    
    @KindMonadicProperty
    public var progress: (IView & IViewProgressable)? {
        didSet {
            guard self.progress !== oldValue else { return }
            self._layout.progress = self.progress
        }
    }
    
    @KindMonadicProperty
    public var error: IView? {
        didSet {
            guard self.error !== oldValue else { return }
            self._layout.error = self.error
        }
    }
    
    public private(set) var isLoading: Bool = false
    
    @KindMonadicSignal
    public let onProgress = Signal< Void, Double >()
    
    @KindMonadicSignal
    public let onFinish: Signal< IView?, KindGraphics.Image > = .init()
    
    @KindMonadicSignal
    public let onError: Signal< Void, KindRemoteImage.Error > = .init()
    
    private var _layout: Layout
    
    public init() {
        self._layout = Layout()
        self.body = KindUI.CustomView()
            .content(self._layout)
        self._setup()
    }
    
}

private extension View {
    
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

public extension View {
    
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

extension View : IViewReusable {
}

#if os(iOS)

extension View : IViewSupportTransform {
}

#endif

extension View : IViewDynamicSizeable {
}

extension View : IViewHighlightable {
}

extension View : IViewLockable {
}

extension View : IViewColorable {
}

extension View : IViewAlphable {
}

extension View : KindRemoteImage.ITarget {
    
    public func remoteImage(progress: Double) {
        self.progress?.progress(progress)
        self.onProgress.emit(progress)
    }
    
    public func remoteImage(image: KindGraphics.Image) {
        self.isLoading = false
        self._layout.state = .loaded
        self.imageView = self.onFinish.emit(image, default: ImageView().image(image))
    }
    
    public func remoteImage(error: KindRemoteImage.Error) {
        self.isLoading = false
        self._layout.state = .error
        self.onError.emit(error)
    }
    
}
