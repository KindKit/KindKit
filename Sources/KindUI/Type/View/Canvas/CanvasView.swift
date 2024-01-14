//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

protocol KKUIViewCanvasDelegate : AnyObject {
    
    func resize(_ size: Size)
    
    func draw(_ context: Context)
    
    func shouldTap(_ gesture: CanvasView.Gesture) -> Bool
    func handle(tap event: CanvasView.Event.Tap)
    
    func shouldLongTap(_ gesture: CanvasView.Gesture) -> Bool
    func handle(longTap event: CanvasView.Event.Tap)
    
    func shouldPan(_ gesture: CanvasView.Gesture) -> Bool
    func handle(pan event: CanvasView.Event.Pan)
    
    func shouldPinch() -> Bool
    func handle(pinch event: CanvasView.Event.Pinch)
    
    func shouldRotation() -> Bool
    func handle(rotation event: CanvasView.Event.Rotation)
    
}

public final class CanvasView {
    
    public private(set) weak var appearedLayout: ILayout?
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(transform: self.transform)
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
    public var color: Color? {
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
    public var isLocked: Bool {
        set {
            guard self._isLocked != newValue else { return }
            self._isLocked = newValue
            if self.isLoaded == true {
                self._view.update(locked: self._isLocked)
            }
            self.triggeredChangeStyle(false)
        }
        get { self._isLocked }
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
    public let onStyle = Signal< Void, Bool >()
    public let onResize = Signal< Void, Size >()
    public let onDraw = Signal< Void, KindGraphics.Context >()
    public let onShouldTap = Signal< Bool?, Gesture >()
    public let onTap = Signal< Void, Event.Tap >()
    public let onShouldLongTap = Signal< Bool?, Gesture >()
    public let onLongTap = Signal< Void, Event.Tap >()
    public let onShouldPan = Signal< Bool?, Gesture >()
    public let onPan = Signal< Void, Event.Pan >()
    public let onShouldPinch = Signal< Bool?, Void >()
    public let onPinch = Signal< Void, Event.Pinch >()
    public let onShouldRotation = Signal< Bool?, Void >()
    public let onRotation = Signal< Void, Event.Rotation >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _isLocked: Bool = false
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

extension CanvasView : IView {
    
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
        return self.size.apply(available: available)
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
    
    public func setNeedRedraw() {
        guard self.isAppeared == true else { return }
#if os(macOS)
        self._view.needsDisplay = true
#elseif os(iOS)
        self._view.setNeedsDisplay()
#endif
    }
    
}

extension CanvasView : IViewReusable {
    
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

extension CanvasView : IViewTransformable {
}

#endif

extension CanvasView : IViewStaticSizeable {
}

extension CanvasView : IViewLockable {
}

extension CanvasView : IViewColorable {
}

extension CanvasView : IViewAlphable {
}

extension CanvasView : KKUIViewCanvasDelegate {
    
    func resize(_ size: Size) {
        self.onResize.emit(size)
    }
    
    func draw(_ context: Context) {
        self.onDraw.emit(context)
    }
    
    func shouldTap(_ gesture: Gesture) -> Bool {
        return self.onShouldTap.emit(gesture) ?? false
    }
    
    func handle(tap event: Event.Tap) {
        self.onTap.emit(event)
    }
    
    func shouldLongTap(_ gesture: Gesture) -> Bool {
        return self.onShouldLongTap.emit(gesture) ?? false
    }
    
    func handle(longTap event: Event.Tap) {
        self.onLongTap.emit(event)
    }
    
    func shouldPan(_ gesture: Gesture) -> Bool {
        return self.onShouldPan.emit(gesture) ?? false
    }
    
    func handle(pan event: Event.Pan) {
        self.onPan.emit(event)
    }
    
    func shouldPinch() -> Bool {
        return self.onShouldPinch.emit() ?? false
    }
    
    func handle(pinch event: Event.Pinch) {
        self.onPinch.emit(event)
    }
    
    func shouldRotation() -> Bool {
        return self.onShouldRotation.emit() ?? false
    }
    
    func handle(rotation event: Event.Rotation) {
        self.onRotation.emit(event)
    }
    
}
