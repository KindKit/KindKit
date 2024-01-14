//
//  KindKit
//

import KindCamera
import KindUI

protocol KKCameraViewDelegate : AnyObject {
    
    func shouldFocus(_ view: KKCameraView) -> Bool
    func focus(_ view: KKCameraView, point: Point)
    
#if os(iOS)
    
    func shouldZoom(_ view: KKCameraView) -> Bool
    func beginZooming(_ view: KKCameraView)
    func zooming(_ view: KKCameraView, _ zoom: Double)
    func endZoom(_ view: KKCameraView)
    
#endif
    
}

public final class View {
    
    public private(set) weak var appearedLayout: ILayout?
    public var frame: KindMath.Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(transform: self.transform)
            }
        }
    }
#endif
    public var size: StaticSize = .init(.fill, .fill) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var cameraSession: KindCamera.Session {
        willSet {
            guard self.cameraSession !== newValue else { return }
            self.cameraSession.remove(observer: self)
            if self.isLoaded == true {
                self._view.kk_update(cameraSession: self.cameraSession)
            }
        }
        didSet {
            guard self.cameraSession !== oldValue else { return }
            self.cameraSession.add(observer: self, priority: .public)
            if self.isLoaded == true {
                self._view.kk_update(cameraSession: self.cameraSession)
            }
        }
    }
    public var mode: Mode = .aspectFit {
        didSet {
            guard self.mode != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(mode: self.mode)
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
                self._view.kk_update(zoom: self._zoom)
            }
        }
        get { self._zoom }
    }
#endif
    public var color: KindGraphics.Color? {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(color: self.color)
            }
        }
    }
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(alpha: self.alpha)
            }
        }
    }
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public private(set) var isVisible: Bool = false
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    public let onFocus = Signal< Void, Point >()
#if os(iOS)
    public let onBeginZooming = Signal< Void, Void >()
    public let onZooming = Signal< Void, Void >()
    public let onEndZooming = Signal< Void, Void >()
#endif
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self, unloadBehaviour: .whenDestroy, cache: nil)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
#if os(iOS)
    private var _zoom: Double = 1
#endif
    
    public init(
        _ cameraSession: KindCamera.Session
    ) {
        self.cameraSession = cameraSession
        self.cameraSession.add(observer: self, priority: .public)
    }
    
    deinit {
        self._reuse.destroy()
    }

}

public extension View {
    
    @inlinable
    @discardableResult
    func cameraSession(_ value: KindCamera.Session) -> Self {
        self.cameraSession = value
        return self
    }
    
    @inlinable
    @discardableResult
    func cameraSession(_ value: () -> KindCamera.Session) -> Self {
        return self.cameraSession(value())
    }

    @inlinable
    @discardableResult
    func cameraSession(_ value: (Self) -> KindCamera.Session) -> Self {
        return self.cameraSession(value(self))
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: () -> Mode) -> Self {
        return self.mode(value())
    }

    @inlinable
    @discardableResult
    func mode(_ value: (Self) -> Mode) -> Self {
        return self.mode(value(self))
    }
    
    @inlinable
    @discardableResult
    func shouldFocus(_ value: Bool) -> Self {
        self.shouldFocus = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldFocus(_ value: () -> Bool) -> Self {
        return self.shouldFocus(value())
    }

    @inlinable
    @discardableResult
    func shouldFocus(_ value: (Self) -> Bool) -> Self {
        return self.shouldFocus(value(self))
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
    func shouldZoom(_ value: () -> Bool) -> Self {
        return self.shouldZoom(value())
    }

    @inlinable
    @discardableResult
    func shouldZoom(_ value: (Self) -> Bool) -> Self {
        return self.shouldZoom(value(self))
    }
    
    @inlinable
    @discardableResult
    func zoom(_ value: Double) -> Self {
        self.zoom = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zoom(_ value: () -> Double) -> Self {
        return self.zoom(value())
    }

    @inlinable
    @discardableResult
    func zoom(_ value: (Self) -> Double) -> Self {
        return self.zoom(value(self))
    }
    
#endif
    
}

public extension View {
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping () -> Void) -> Self {
        self.onFocus.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping (Self) -> Void) -> Self {
        self.onFocus.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping (Point) -> Void) -> Self {
        self.onFocus.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus(_ closure: @escaping (Self, Point) -> Void) -> Self {
        self.onFocus.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onFocus.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFocus< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Point) -> Void) -> Self {
        self.onFocus.add(sender, closure)
        return self
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func onBeginZooming(_ closure: @escaping () -> Void) -> Self {
        self.onBeginZooming.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginZooming(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginZooming.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginZooming< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginZooming.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming(_ closure: @escaping () -> Void) -> Self {
        self.onZooming.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming(_ closure: @escaping (Self) -> Void) -> Self {
        self.onZooming.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onZooming< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onZooming.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming(_ closure: @escaping () -> Void) -> Self {
        self.onEndZooming.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndZooming.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndZooming< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndZooming.add(sender, closure)
        return self
    }
    
#endif
    
}

extension View : IView {
    
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
    
    public func appear(to layout: ILayout) {
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
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension View : IViewReusable {
    
    public var reuseUnloadBehaviour: Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: ReuseCache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension View : IViewTransformable {
}

#endif

extension View : IViewStaticSizeable {
}

extension View : IViewColorable {
}

extension View : IViewAlphable {
}

extension View : KindCamera.IObserver {
    
    public func started(_ camera: KindCamera.Session) {
        if self.isLoaded == true {
#if os(iOS)
            self._view.kk_update(zoom: self._zoom)
#endif
        }
    }
    
    public func stopped(_ camera: KindCamera.Session) {
    }
    
#if os(iOS)
    
    public func changed(_ camera: KindCamera.Session, interfaceOrientation: KindCamera.Orientation?) {
        self._view.kk_update(orientation: interfaceOrientation)
    }
    
#endif
    
    public func startConfiguration(_ camera: KindCamera.Session) {
        if self.isLoaded == true {
            let outputs = camera.activeOutputs.compactMap({ $0 as? KindCamera.Output.Frame })
            self._view.kk_startConfiguration(outputs.first?.frame)
        }
    }
    
    public func finishConfiguration(_ camera: KindCamera.Session) {
#if os(iOS)
        self._zoom = 1
#endif
        if self.isLoaded == true {
            self._view.kk_finishConfiguration()
        }
    }
    
}

extension View : KKCameraViewDelegate {
    
    func shouldFocus(_ view: KKCameraView) -> Bool {
        return self.shouldFocus
    }
    
    func focus(_ view: KKCameraView, point: Point) {
        self.onFocus.emit(point)
    }
    
#if os(iOS)
    
    func shouldZoom(_ view: KKCameraView) -> Bool {
        return self.shouldZoom
    }
    
    func beginZooming(_ view: KKCameraView) {
        if self.isZooming == false {
            self.isZooming = true
            self.onBeginZooming.emit()
        }
    }
    
    func zooming(_ view: KKCameraView, _ zoom: Double) {
        if self._zoom != zoom {
            self._zoom = zoom
            if self.isZooming == true {
                self.onZooming.emit()
            }
        }
    }
    
    func endZoom(_ view: KKCameraView) {
        if self.isZooming == true {
            self.isZooming = false
            self.onEndZooming.emit()
        }
    }
    
#endif
    
}
