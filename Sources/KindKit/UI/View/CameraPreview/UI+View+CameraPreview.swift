//
//  KindKit
//

import Foundation

protocol KKCameraPreviewViewDelegate : AnyObject {
    
    func shouldFocus(_ view: KKCameraPreviewView) -> Bool
    func focus(_ view: KKCameraPreviewView, point: Point)
    
#if os(iOS)
    
    func shouldZoom(_ view: KKCameraPreviewView) -> Bool
    func beginZooming(_ view: KKCameraPreviewView)
    func zooming(_ view: KKCameraPreviewView, _ zoom: Double)
    func endZoom(_ view: KKCameraPreviewView)
    
#endif
    
}

public extension UI.View {

    final class CameraPreview {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Static = .init(.fill, .fill) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var cameraSession: CameraSession {
            willSet {
                guard self.cameraSession !== newValue else { return }
                self.cameraSession.remove(observer: self)
                if self.isLoaded == true {
                    self._view.update(cameraSession: self.cameraSession)
                }
            }
            didSet {
                guard self.cameraSession !== oldValue else { return }
                self.cameraSession.add(observer: self, priority: .public)
                if self.isLoaded == true {
                    self._view.update(cameraSession: self.cameraSession)
                }
            }
        }
        public var mode: Mode = .aspectFit {
            didSet {
                guard self.mode != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(mode: self.mode)
                }
            }
        }
        public var shouldFocus: Bool = true
#if os(iOS)
        public var shouldZoom: Bool = true
        public private(set) var isZooming: Bool = false
        public var zoom: Double {
            set {
                guard self._zoom != newValue else { return }
                if self.isLoaded == true {
                    self._view.update(zoom: self._zoom)
                }
            }
            get { self._zoom }
        }
#endif
        public var color: UI.Color? {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(color: self.color)
                }
            }
        }
        public var alpha: Double = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(alpha: self.alpha)
                }
            }
        }
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onFocus: Signal.Args< Void, Point > = .init()
#if os(iOS)
        public let onBeginZooming: Signal.Empty< Void > = .init()
        public let onZooming: Signal.Empty< Void > = .init()
        public let onEndZooming: Signal.Empty< Void > = .init()
#endif
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy, cache: nil)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
#if os(iOS)
        private var _zoom: Double = 1
#endif
        
        public init(
            _ cameraSession: CameraSession
        ) {
            self.cameraSession = cameraSession
            self.cameraSession.add(observer: self, priority: .public)
        }
        
        deinit {
            self._reuse.destroy()
        }

    }
    
}

public extension UI.View.CameraPreview {
    
    @inlinable
    @discardableResult
    func cameraSession(_ value: CameraSession) -> Self {
        self.cameraSession = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldFocus(_ value: Bool) -> Self {
        self.shouldFocus = value
        return self
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func shouldZoom(_ value: Bool) -> Self {
        self.shouldZoom = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zoom(_ value: Double) -> Self {
        self.zoom = value
        return self
    }
    
#endif
    
}

public extension UI.View.CameraPreview {
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: (() -> Void)?) -> Self {
        self.onFocus.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: ((Self) -> Void)?) -> Self {
        self.onFocus.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: ((Point) -> Void)?) -> Self {
        self.onFocus.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: ((Self, Point) -> Void)?) -> Self {
        self.onFocus.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onFocus.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Point) -> Void)?) -> Self {
        self.onFocus.link(sender, closure)
        return self
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func onBeginZooming(_ closure: (() -> Void)?) -> Self {
        self.onBeginZooming.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginZooming(_ closure: ((Self) -> Void)?) -> Self {
        self.onBeginZooming.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginZooming< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onBeginZooming.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming(_ closure: (() -> Void)?) -> Self {
        self.onZooming.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming(_ closure: ((Self) -> Void)?) -> Self {
        self.onZooming.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onZooming.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming(_ closure: (() -> Void)?) -> Self {
        self.onEndZooming.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming(_ closure: ((Self) -> Void)?) -> Self {
        self.onEndZooming.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onEndZooming.link(sender, closure)
        return self
    }
    
#endif
    
}

extension UI.View.CameraPreview : IUIView {
    
    public var native: NativeView {
        return self._view
    }
    
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(
            available: available
        )
    }
    
    public func appear(to layout: IUILayout) {
        self.appearedLayout = layout
        self.onAppear.emit()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.appearedLayout = nil
        self.onDisappear.emit()
    }
    
    public func visible() {
        self.isVisible = true
        self.onVisible.emit()
    }
    
    public func visibility() {
        self.onVisibility.emit()
    }
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension UI.View.CameraPreview : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension UI.View.CameraPreview : IUIViewTransformable {
}

#endif

extension UI.View.CameraPreview : IUIViewStaticSizeable {
}

extension UI.View.CameraPreview : IUIViewColorable {
}

extension UI.View.CameraPreview : IUIViewAlphable {
}

extension UI.View.CameraPreview : ICameraSessionObserver {
    
    public func started(_ camera: CameraSession) {
        if self.isLoaded == true {
            self._view.update(videoDevice: camera.activeVideoDevice)
#if os(iOS)
            self._view.update(zoom: self._zoom)
#endif
        }
    }
    
    public func stopped(_ camera: CameraSession) {
        if self.isLoaded == true {
            self._view.update(videoDevice: nil)
        }
    }
    
#if os(iOS)
    
    public func changed(_ camera: CameraSession, interfaceOrientation: CameraSession.Orientation?) {
        self._view.update(orientation: interfaceOrientation)
    }
    
#endif
    
    public func startConfiguration(_ camera: CameraSession) {
        if self.isLoaded == true {
            self._view.update(videoDevice: nil)
        }
    }
    
    public func finishConfiguration(_ camera: CameraSession) {
#if os(iOS)
        self._zoom = 1
#endif
        if self.isLoaded == true {
            self._view.update(videoDevice: camera.activeVideoDevice)
        }
    }
    
}

extension UI.View.CameraPreview : KKCameraPreviewViewDelegate {
    
    func shouldFocus(_ view: KKCameraPreviewView) -> Bool {
        return self.shouldFocus
    }
    
    func focus(_ view: KKCameraPreviewView, point: Point) {
        self.onFocus.emit(point)
    }
    
#if os(iOS)
    
    func shouldZoom(_ view: KKCameraPreviewView) -> Bool {
        return self.shouldZoom
    }
    
    func beginZooming(_ view: KKCameraPreviewView) {
        if self.isZooming == false {
            self.isZooming = true
            self.onBeginZooming.emit()
        }
    }
    
    func zooming(_ view: KKCameraPreviewView, _ zoom: Double) {
        if self._zoom != zoom {
            self._zoom = zoom
            if self.isZooming == true {
                self.onZooming.emit()
            }
        }
    }
    
    func endZoom(_ view: KKCameraPreviewView) {
        if self.isZooming == true {
            self.isZooming = false
            self.onEndZooming.emit()
        }
    }
    
#endif
    
}

public extension IUIView where Self == UI.View.CameraPreview {
    
    @inlinable
    static func cameraPreview(
        _ cameraSession: CameraSession
    ) -> Self {
        return .init(cameraSession)
    }
    
}
