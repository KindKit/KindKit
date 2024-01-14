//
//  KindKit
//

import KindAnimation
import KindGraphics
import KindMath
import KindEvent

public protocol IScrollViewObserver : AnyObject {
    
    func beginDragging(scroll: ScrollView)
    func dragging(scroll: ScrollView)
    func endDragging(scroll: ScrollView, decelerate: Bool)
    func beginDecelerating(scroll: ScrollView)
    func endDecelerating(scroll: ScrollView)
    
    func beginZooming(scroll: ScrollView)
    func zooming(scroll: ScrollView)
    func endZooming(scroll: ScrollView)
    
    func scrollToTop(scroll: ScrollView)
    
}

protocol KKScrollViewDelegate : AnyObject {
    
    func isDynamic(_ view: KKScrollView) -> Bool
    
    func update(_ view: KKScrollView, contentSize: Size)
    
    func triggeredRefresh(_ view: KKScrollView)
    
    func beginDragging(_ view: KKScrollView)
    func dragging(_ view: KKScrollView, contentOffset: Point)
    func endDragging(_ view: KKScrollView, decelerate: Bool)
    func beginDecelerating(_ view: KKScrollView)
    func endDecelerating(_ view: KKScrollView)
    
    func beginZooming(_ view: KKScrollView)
    func zooming(_ view: KKScrollView, zoom: Double)
    func endZooming(_ view: KKScrollView)
    
    func scrollToTop(_ view: KKScrollView)
    
}

public final class ScrollView {
    
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
    public var size: DynamicSize = .init(.fill, .fill) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var bounce: Bounce = [ .vertical, .zoom ] {
        didSet {
            guard self.bounce != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(bounce: self.bounce)
            }
        }
    }
    public var direction: Direction = .vertical {
        didSet {
            guard self.direction != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(direction: self.direction)
            }
        }
    }
    public var indicatorDirection: Direction = .vertical {
        didSet {
            guard self.indicatorDirection != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(indicatorDirection: self.indicatorDirection)
            }
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
        }
    }
    public private(set) var contentSize: Size = .zero
    public var contentInset: Inset = .zero {
        didSet {
            guard self.contentInset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(contentInset: self.contentInset)
            }
            let deltaContentInset = self.contentInset - oldValue
            let oldContentOffset = self.contentOffset
            let newContentOffset = Point(
                x: max(-self.contentInset.left, oldContentOffset.x - deltaContentInset.left),
                y: max(-self.contentInset.top, oldContentOffset.y - deltaContentInset.top)
            )
            if oldContentOffset != newContentOffset {
                self._contentOffset = newContentOffset
                if self.isLoaded == true {
                    self._view.update(contentOffset: newContentOffset)
                }
            }
            if self.size.isStatic == false {
                self.setNeedLayout()
            }
        }
    }
    public var contentOffset: Point {
        set {
            guard self._contentOffset != newValue else { return }
            self._contentOffset = newValue
            if self.isLoaded == true {
                self._view.update(contentOffset: newValue)
            }
        }
        get { self._contentOffset }
    }
    public var visibleInset: Inset = .zero {
        didSet {
            guard self.visibleInset != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(visibleInset: self.visibleInset)
            }
        }
    }
    public var zoom: Double {
        set {
            guard self._zoom != newValue else { return }
            self._zoom = newValue
            if self.isLoaded == true {
                self._view.update(zoom: self._zoom, limit: self.zoomLimit)
            }
        }
        get { self._zoom }
    }
    public var zoomLimit: Range< Double > = 1.0..<1.0 {
        didSet {
            guard self.zoomLimit != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(zoom: self._zoom, limit: self.zoomLimit)
            }
        }
    }
#if os(iOS)
    public var delaysContentTouches: Bool = true {
        didSet {
            guard self.delaysContentTouches != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(delaysContentTouches: self.delaysContentTouches)
            }
        }
    }
    public var refreshColor: Color? {
        set {
            guard self._refreshColor != newValue else { return }
            self._refreshColor = newValue
            if self.isLoaded == true {
                self._view.update(refreshColor: self._refreshColor)
            }
        }
        get { self._refreshColor }
    }
    public var isRefreshing: Bool {
        set {
            guard self._isRefreshing != newValue else { return }
            self._isRefreshing = newValue
            if self.isLoaded == true {
                self._view.update(isRefreshing: self._isRefreshing)
            }
        }
        get { self._isRefreshing }
    }
#endif
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
    public private(set) var isDragging: Bool = false
    public private(set) var isDecelerating: Bool = false
    public private(set) var isZooming: Bool = false
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    public let onStyle = Signal< Void, Bool >()
    public let onScrollToTop = Signal< Void, Void >()
    public let onBeginDragging = Signal< Void, Void >()
    public let onDragging = Signal< Void, Void >()
    public let onEndDragging = Signal< Void, Bool >()
    public let onBeginDecelerating = Signal< Void, Void >()
    public let onEndDecelerating = Signal< Void, Void >()
    public let onBeginZooming = Signal< Void, Void >()
    public let onZooming = Signal< Void, Void >()
    public let onEndZooming = Signal< Void, Void >()
    public let onTriggeredRefresh = Signal< Void, Void >()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _contentOffset: Point = .zero
    private var _zoom: Double = 1.0
    private var _refreshColor: KindGraphics.Color?
    private var _isRefreshing: Bool = false
    private var _isLocked: Bool = false
    private var _observer: Observer< IScrollViewObserver > = .init()
    private var _animation: ICancellable? {
        willSet { self._animation?.cancel() }
    }
    
    public init() {
    }
    
    deinit {
        self._destroy()
    }
    
    public func add(observer: IScrollViewObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    public func remove(observer: IScrollViewObserver) {
        self._observer.remove(observer)
    }
    
}

private extension ScrollView {
    
    func _destroy() {
        self._reuse.destroy()
        self._animation = nil
    }
    
    func _scrollToTop() {
        self.onScrollToTop.emit()
        self._observer.emit({ $0.scrollToTop(scroll: self) })
    }
    
}

public extension ScrollView {
    
    var estimatedContentOffset: Point {
        let size = self.bounds.size
        let contentOffset = self.contentOffset
        let contentSize = self.contentSize
        let contentInset = self.contentInset
        return Point(
            x: (contentInset.left + contentSize.width + contentInset.right) - (contentOffset.x + size.width),
            y: (contentInset.top + contentSize.height + contentInset.bottom) - (contentOffset.y + size.height)
        )
    }
    
}

public extension ScrollView {
    
    func contentOffset(
        with view: IView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) -> Point? {
        return self.contentOffset(
            with: view.native,
            horizontal: horizontal,
            vertical: vertical
        )
    }
    
    func contentOffset(
        with view: NativeView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) -> Point? {
        guard self.isLoaded == true else {
            return nil
        }
        self.layoutIfNeeded()
        guard let contentOffset = self._view.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return nil
        }
        return Point(contentOffset)
    }
    
#if os(iOS)
    
    @discardableResult
    func beginRefresh() -> Self {
        self.isRefreshing = true
        return self
    }
    
    @discardableResult
    func endRefresh() -> Self {
        self.isRefreshing = false
        return self
    }
    
#endif
    
    func scroll(
        to view: IView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment,
        velocity: Double? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.scroll(
            to: to,
            velocity: velocity,
            animated: animated,
            completion: completion
        )
    }
    
    func scrollToTop(
        velocity: Double? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let contentInset = self.contentInset
        self.scroll(
            to: Point(x: -contentInset.left, y: -contentInset.top),
            velocity: velocity,
            animated: animated,
            completion: completion
        )
    }
    
    func scroll(
        to: Point,
        velocity: Double? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let beginContentOffset = self.contentOffset
        let endContentOffset = to
        let deltaContentOffset = beginContentOffset.length(endContentOffset).abs
        if animated == true && deltaContentOffset > .zero {
            let velocity = velocity ?? max(self.bounds.width, self.bounds.height) * 5
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(deltaContentOffset.value / velocity),
                    ease: KindAnimation.Ease.QuadraticInOut(),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        let contentOffset = beginContentOffset.lerp(endContentOffset, progress: progress)
                        self.contentOffset(contentOffset)
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._scrollToTop()
                        completion?()
                    }
                )
            )
        } else {
            self.contentOffset = to
            self._scrollToTop()
            completion?()
        }
    }
    
}

public extension ScrollView {
    
    @discardableResult
    func contentOffset(_ value: Point) -> Self {
        self.contentOffset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentOffset(_ value: () -> Point) -> Self {
        return self.contentOffset(value())
    }

    @inlinable
    @discardableResult
    func contentOffset(_ value: (Self) -> Point) -> Self {
        return self.contentOffset(value(self))
    }
    
    @discardableResult
    func content(_ value: ILayout?) -> Self {
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
    
    @inlinable
    @discardableResult
    func bounce(_ value: Bounce) -> Self {
        self.bounce = value
        return self
    }
    
    @inlinable
    @discardableResult
    func bounce(_ value: () -> Bounce) -> Self {
        return self.bounce(value())
    }

    @inlinable
    @discardableResult
    func bounce(_ value: (Self) -> Bounce) -> Self {
        return self.bounce(value(self))
    }
    
    @inlinable
    @discardableResult
    func direction(_ value: Direction) -> Self {
        self.direction = value
        return self
    }
    
    @inlinable
    @discardableResult
    func direction(_ value: () -> Direction) -> Self {
        return self.direction(value())
    }

    @inlinable
    @discardableResult
    func direction(_ value: (Self) -> Direction) -> Self {
        return self.direction(value(self))
    }
    
    @inlinable
    @discardableResult
    func indicatorDirection(_ value: Direction) -> Self {
        self.indicatorDirection = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicatorDirection(_ value: () -> Direction) -> Self {
        return self.indicatorDirection(value())
    }

    @inlinable
    @discardableResult
    func indicatorDirection(_ value: (Self) -> Direction) -> Self {
        return self.indicatorDirection(value(self))
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
    
    @inlinable
    @discardableResult
    func zoomLimit(_ value: Range< Double >) -> Self {
        self.zoomLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zoomLimit(_ value: () -> Range< Double >) -> Self {
        return self.zoomLimit(value())
    }

    @inlinable
    @discardableResult
    func zoomLimit(_ value: (Self) -> Range< Double >) -> Self {
        return self.zoomLimit(value(self))
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func delaysContentTouches(_ value: Bool) -> Self {
        self.delaysContentTouches = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysContentTouches(_ value: () -> Bool) -> Self {
        return self.delaysContentTouches(value())
    }

    @inlinable
    @discardableResult
    func delaysContentTouches(_ value: (Self) -> Bool) -> Self {
        return self.delaysContentTouches(value(self))
    }
    
    @inlinable
    @discardableResult
    func refreshColor(_ value: Color?) -> Self {
        self.refreshColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func refreshColor(_ value: () -> Color?) -> Self {
        return self.refreshColor(value())
    }

    @inlinable
    @discardableResult
    func refreshColor(_ value: (Self) -> Color?) -> Self {
        return self.refreshColor(value(self))
    }
    
#endif
    
}

public extension ScrollView {
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh(_ closure: @escaping () -> Void) -> Self {
        self.onTriggeredRefresh.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh(_ closure: @escaping (Self) -> Void) -> Self {
        self.onTriggeredRefresh.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onTriggeredRefresh.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop(_ closure: @escaping () -> Void) -> Self {
        self.onScrollToTop.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop(_ closure: @escaping (Self) -> Void) -> Self {
        self.onScrollToTop.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onScrollToTop.add(sender, closure)
        return self
    }
    
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
    
}

extension ScrollView : IView {
    
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
                return content.size(available: $0).inset(-self.contentInset)
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

extension ScrollView : IViewReusable {
    
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

extension ScrollView : IViewTransformable {
}

#endif

extension ScrollView : IViewDynamicSizeable {
}

extension ScrollView : IViewScrollable {
}

extension ScrollView : IViewColorable {
}

extension ScrollView : IViewAlphable {
}

extension ScrollView : IViewLockable {
}

extension ScrollView : KKScrollViewDelegate {
    
    func isDynamic(_ view: KKScrollView) -> Bool {
        return self.width.isStatic == false || self.height.isStatic == false
    }
    
    func update(_ view: KKScrollView, contentSize: Size) {
        self.contentSize = contentSize
    }
    
    func triggeredRefresh(_ view: KKScrollView) {
        self.onTriggeredRefresh.emit()
    }
    
    func beginDragging(_ view: KKScrollView) {
        if self.isDragging == false {
            self.isDragging = true
            self.onBeginDragging.emit()
            self._observer.emit({ $0.beginDragging(scroll: self) })
        }
    }
    
    func dragging(_ view: KKScrollView, contentOffset: Point) {
        if self._contentOffset != contentOffset {
            self._contentOffset = contentOffset
            self.onDragging.emit()
            self._observer.emit({ $0.dragging(scroll: self) })
        }
    }
    
    func endDragging(_ view: KKScrollView, decelerate: Bool) {
        if self.isDragging == true {
            self.isDragging = false
            self.onEndDragging.emit(decelerate)
            self._observer.emit({ $0.endDragging(scroll: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self.onBeginDecelerating.emit()
            self._observer.emit({ $0.beginDecelerating(scroll: self) })
        }
    }
    
    func endDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self.onEndDecelerating.emit()
            self._observer.emit({ $0.endDecelerating(scroll: self) })
        }
    }
    
    func beginZooming(_ view: KKScrollView) {
        if self.isZooming == false {
            self.isZooming = true
            self.onBeginZooming.emit()
            self._observer.emit({ $0.beginZooming(scroll: self) })
        }
    }
    
    func zooming(_ view: KKScrollView, zoom: Double) {
        if self._zoom != zoom {
            self._zoom = zoom
            self.onZooming.emit()
            self._observer.emit({ $0.zooming(scroll: self) })
        }
    }
    
    func endZooming(_ view: KKScrollView) {
        if self.isZooming == true {
            self.isZooming = false
            self.onEndZooming.emit()
            self._observer.emit({ $0.endZooming(scroll: self) })
        }
    }
    
    func scrollToTop(_ view: KKScrollView) {
        self._scrollToTop()
    }
    
}
