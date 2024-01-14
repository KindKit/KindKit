//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

protocol KKControlViewDelegate : AnyObject {
    
    func isDynamic(_ view: KKControlView) -> Bool
    
    func shouldHighlighting(_ view: KKControlView) -> Bool
    func set(_ view: KKControlView, highlighted: Bool)
    
    func shouldPressing(_ view: KKControlView) -> Bool
    func pressed(_ view: KKControlView)
    
}

public final class ControlView {
    
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
    public var size: DynamicSize = .init(.fit, .fit) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var content: ILayout? {
        willSet {
            guard self.content !== newValue else { return }
            self.content?.appearedView = nil
        }
        didSet {
            guard self.content !== oldValue else { return }
            self.content?.appearedView = self
            if self.isLoaded == true {
                self._view.update(content: self.content)
            }
            self.content?.setNeedUpdate()
            self.setNeedLayout()
        }
    }
    public var contentSize: Size {
        guard self.isLoaded == true else { return .zero }
        return self._view.kkContentSize
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
    public var shouldPressed: Bool = false
    public var shouldHighlighting: Bool = false {
        didSet {
            if self.shouldHighlighting == false {
                self.isHighlighted = false
            }
        }
    }
    public var isHighlighted: Bool {
        set {
            guard self._isHighlighted != newValue else { return }
            self._isHighlighted = newValue
            self.triggeredChangeStyle(false)
        }
        get { self._isHighlighted }
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
    public let onPressed = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _isHighlighted: Bool = false
    private var _isLocked: Bool = false
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}


public extension ControlView {
    
    @inlinable
    @discardableResult
    func content(_ value: ILayout) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> ILayout) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> ILayout) -> Self {
        return self.content(value(self))
    }
    
}

extension ControlView : IView {
    
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
            available: available,
            size: {
                guard let content = self.content else { return .zero }
                return content.size(available: $0)
            }
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

extension ControlView : IViewReusable {
    
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

extension ControlView : IViewTransformable {
}

#endif

extension ControlView :  IViewDynamicSizeable{
}

extension ControlView : IViewColorable {
}

extension ControlView : IViewAlphable {
}

extension ControlView : IViewHighlightable {
}

extension ControlView : IViewLockable {
}

extension ControlView : IViewPressable {
}

extension ControlView : KKControlViewDelegate {
    
    func isDynamic(_ view: KKControlView) -> Bool {
        return self.width.isStatic == false || self.height.isStatic == false
    }
    
    func shouldHighlighting(_ view: KKControlView) -> Bool {
        return self.shouldHighlighting
    }
    
    func set(_ view: KKControlView, highlighted: Bool) {
        if self._isHighlighted != highlighted {
            self._isHighlighted = highlighted
            self.onStyle.emit(true)
        }
    }
    
    func shouldPressing(_ view: KKControlView) -> Bool {
        return self.shouldPressed
    }
    
    func pressed(_ view: KKControlView) {
        self.onPressed.emit()
    }
    
}
