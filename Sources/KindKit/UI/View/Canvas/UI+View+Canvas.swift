//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKUIViewCanvasDelegate : AnyObject {
    
    func resize(_ size: Size)
    
    func draw(_ context: Graphics.Context)
    
    func shouldTap(_ gesture: UI.View.Canvas.Gesture) -> Bool
    func handle(tap event: UI.View.Canvas.Event.Tap)
    
    func shouldLongTap(_ gesture: UI.View.Canvas.Gesture) -> Bool
    func handle(longTap event: UI.View.Canvas.Event.Tap)
    
    func shouldPan(_ gesture: UI.View.Canvas.Gesture) -> Bool
    func handle(pan event: UI.View.Canvas.Event.Pan)
    
    func shouldPinch() -> Bool
    func handle(pinch event: UI.View.Canvas.Event.Pinch)
    
    func shouldRotation() -> Bool
    func handle(rotation event: UI.View.Canvas.Event.Rotation)
    
}

public extension UI.View {
    
    final class Canvas {
        
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
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onVisibility = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        public let onStyle = Signal.Args< Void, Bool >()
        public let onResize = Signal.Args< Void, Size >()
        public let onDraw = Signal.Args< Void, Graphics.Context >()
        public let onShouldTap = Signal.Args< Bool?, Gesture >()
        public let onTap = Signal.Args< Void, Event.Tap >()
        public let onShouldLongTap = Signal.Args< Bool?, Gesture >()
        public let onLongTap = Signal.Args< Void, Event.Tap >()
        public let onShouldPan = Signal.Args< Bool?, Gesture >()
        public let onPan = Signal.Args< Void, Event.Pan >()
        public let onShouldPinch = Signal.Empty< Bool? >()
        public let onPinch = Signal.Args< Void, Event.Pinch >()
        public let onShouldRotation = Signal.Empty< Bool? >()
        public let onRotation = Signal.Args< Void, Event.Rotation >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _isLocked: Bool = false
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

extension UI.View.Canvas : IUIView {
    
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
    
    public func setNeedRedraw() {
        guard self.isAppeared == true else { return }
        self._view.setNeedsDisplay()
    }
    
}

extension UI.View.Canvas : IUIViewReusable {
    
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

extension UI.View.Canvas : IUIViewTransformable {
}

#endif

extension UI.View.Canvas : IUIViewStaticSizeable {
}

extension UI.View.Canvas : IUIViewLockable {
}

extension UI.View.Canvas : IUIViewColorable {
}

extension UI.View.Canvas : IUIViewAlphable {
}

extension UI.View.Canvas : KKUIViewCanvasDelegate {
    
    func resize(_ size: Size) {
        self.onResize.emit(size)
    }
    
    func draw(_ context: Graphics.Context) {
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

public extension IUIView where Self == UI.View.Canvas {
    
    @inlinable
    static func canvas() -> Self {
        return .init()
    }
    
}

#endif
