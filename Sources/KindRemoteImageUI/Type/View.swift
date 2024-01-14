//
//  KindKit
//

import KindRemoteImage
import KindUI

public final class View : IWidgetView {
    
    public let body: KindUI.CustomView
    public let loader: KindRemoteImage.Loader = .shared
    public var query: KindRemoteImage.IQuery?
    public var filter: KindRemoteImage.IFilter?
    public var placeholder: IView? {
        didSet {
            guard self.placeholder !== oldValue else { return }
            self._layout.placeholder = self.placeholder
        }
    }
    public private(set) var imageView: IView? {
        didSet {
            guard self.imageView !== oldValue else { return }
            self._layout.image = self.imageView
        }
    }
    public var progress: (IView & IViewProgressable)? {
        didSet {
            guard self.progress !== oldValue else { return }
            self._layout.progress = self.progress
        }
    }
    public var error: IView? {
        didSet {
            guard self.error !== oldValue else { return }
            self._layout.error = self.error
        }
    }
    public private(set) var isLoading: Bool = false
    public let onProgress = Signal< Void, Double >()
    public let onFinish: Signal< IView?, KindGraphics.Image > = .init()
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

public extension View {
    
    @inlinable
    @discardableResult
    func placeholder(_ value: IView) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: () -> IView) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder(_ value: (Self) -> IView) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func progress(_ value: (IView & IViewProgressable)?) -> Self {
        self.progress = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progress(_ value: (Self) -> (IView & IViewProgressable)?) -> Self {
        return self.progress(value(self))
    }
    
    @inlinable
    @discardableResult
    func error(_ value: IView?) -> Self {
        self.error = value
        return self
    }
    
    @inlinable
    @discardableResult
    func error(_ value: () -> IView?) -> Self {
        return self.error(value())
    }

    @inlinable
    @discardableResult
    func error(_ value: (Self) -> IView?) -> Self {
        return self.error(value(self))
    }
    
    @inlinable
    @discardableResult
    func query(_ value: KindRemoteImage.IQuery) -> Self {
        self.query = value
        return self
    }
    
    @inlinable
    @discardableResult
    func query(_ value: () -> KindRemoteImage.IQuery) -> Self {
        return self.query(value())
    }

    @inlinable
    @discardableResult
    func query(_ value: (Self) -> KindRemoteImage.IQuery) -> Self {
        return self.query(value(self))
    }
    
    @inlinable
    @discardableResult
    func filter(_ value: KindRemoteImage.IFilter?) -> Self {
        self.filter = value
        return self
    }
    
    @inlinable
    @discardableResult
    func filter(_ value: () -> KindRemoteImage.IFilter?) -> Self {
        return self.filter(value())
    }

    @inlinable
    @discardableResult
    func filter(_ value: (Self) -> KindRemoteImage.IFilter?) -> Self {
        return self.filter(value(self))
    }
    
}

public extension View {
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: @escaping () -> Void) -> Self {
        self.onProgress.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: @escaping (Self) -> Void) -> Self {
        self.onProgress.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: @escaping (Double) -> Void) -> Self {
        self.onProgress.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress(_ closure: @escaping (Self, Double) -> Void) -> Self {
        self.onProgress.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onProgress.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProgress< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Double) -> Void) -> Self {
        self.onProgress.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping () -> IView?) -> Self {
        self.onFinish.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (Self) -> IView?) -> Self {
        self.onFinish.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (KindGraphics.Image) -> IView?) -> Self {
        self.onFinish.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (Self, KindGraphics.Image) -> IView?) -> Self {
        self.onFinish.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> IView?) -> Self {
        self.onFinish.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, KindGraphics.Image) -> IView?) -> Self {
        self.onFinish.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: @escaping () -> Void) -> Self {
        self.onError.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: @escaping (Self) -> Void) -> Self {
        self.onError.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: @escaping (KindRemoteImage.Error) -> Void) -> Self {
        self.onError.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError(_ closure: @escaping (Self, KindRemoteImage.Error) -> Void) -> Self {
        self.onError.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onError.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onError< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, KindRemoteImage.Error) -> Void) -> Self {
        self.onError.add(sender, closure)
        return self
    }
    
}

extension View : IViewReusable {
}

#if os(iOS)

extension View : IViewTransformable {
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
