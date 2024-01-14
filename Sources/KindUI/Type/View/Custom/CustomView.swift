//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

protocol KKCustomViewDelegate : AnyObject {
    
    func isDynamic(_ view: KKCustomView) -> Bool
    
    func shouldHighlighting(_ view: KKCustomView) -> Bool
    func set(_ view: KKCustomView, highlighted: Bool)
    func hasHit(_ view: KKCustomView, point: Point) -> Bool
    
}

public final class CustomView {
    
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
    public var gestures: [IGesture] {
        set {
            self._gestures = newValue
            if self.isLoaded == true {
                self._view.update(gestures: newValue)
            }
        }
        get { self._gestures }
    }
    public var dragDestination: DragAndDrop.Destination? {
        didSet {
            guard self.dragDestination !== oldValue else { return }
            if self.isLoaded == true {
                self._view.update(dragDestination: self.dragDestination)
            }
        }
    }
    public var dragSource: DragAndDrop.Source? {
        didSet {
            guard self.dragSource !== oldValue else { return }
            if self.isLoaded == true {
                self._view.update(dragSource: self.dragSource)
            }
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
    public let onHit = Signal< Bool?, Point >()
    public let onStyle = Signal< Void, Bool >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _gestures: [IGesture] = []
    private var _isHighlighted: Bool = false
    private var _isLocked: Bool = false
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }

}

public extension CustomView {
    
    @inlinable
    @discardableResult
    func gestures(_ value: [IGesture]) -> Self {
        self.gestures = value
        return self
    }
    
    @inlinable
    @discardableResult
    func gestures(_ value: () -> [IGesture]) -> Self {
        return self.gestures(value())
    }

    @inlinable
    @discardableResult
    func gestures(_ value: (Self) -> [IGesture]) -> Self {
        return self.gestures(value(self))
    }
    
    @discardableResult
    func add(gesture: IGesture) -> Self {
        if self._gestures.contains(where: { $0 === gesture }) == false {
            self._gestures.append(gesture)
            if self.isLoaded == true {
                self._view.add(gesture: gesture)
            }
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func add(gesture: (Self) -> IGesture) -> Self {
        return self.add(gesture: gesture(self))
    }
    
    @discardableResult
    func remove(gesture: IGesture) -> Self {
        if let index = self._gestures.firstIndex(where: { $0 === gesture }) {
            self._gestures.remove(at: index)
            if self.isLoaded == true {
                self._view.remove(gesture: gesture)
            }
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func remove(gesture: (Self) -> IGesture) -> Self {
        return self.remove(gesture: gesture(self))
    }
    
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

extension CustomView : IView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
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

extension CustomView : IViewReusable {
    
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

extension CustomView : IViewTransformable {
}

#endif

extension CustomView : IViewDynamicSizeable {
}

extension CustomView : IViewDragDestinationtable {
}

extension CustomView : IViewDragSourceable {
}

extension CustomView : IViewHighlightable {
}

extension CustomView : IViewLockable {
}

extension CustomView : IViewHitable {
}

extension CustomView : IViewColorable {
}

extension CustomView : IViewAlphable {
}

extension CustomView : KKCustomViewDelegate {
    
    func isDynamic(_ view: KKCustomView) -> Bool {
        return self.width.isStatic == false || self.height.isStatic == false
    }
    
    func shouldHighlighting(_ view: KKCustomView) -> Bool {
        return self.shouldHighlighting
    }
    
    func set(_ view: KKCustomView, highlighted: Bool) {
        if self._isHighlighted != highlighted {
            self._isHighlighted = highlighted
            self.triggeredChangeStyle(true)
        }
    }
    
    func hasHit(_ view: KKCustomView, point: Point) -> Bool {
        return self.onHit.emit(point, default: { [unowned self] in
            let shouldHighlighting = self.shouldHighlighting
            let shouldGestures = self.gestures.contains(where: { $0.isEnabled })
            return shouldHighlighting == true || shouldGestures == true
        })
    }
    
}
