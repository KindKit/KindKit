//
//  KindKit
//

import Foundation

public protocol IUIScrollViewObserver : AnyObject {
    
    func beginDragging(scroll: UI.View.Scroll)
    func dragging(scroll: UI.View.Scroll)
    func endDragging(scroll: UI.View.Scroll, decelerate: Bool)
    func beginDecelerating(scroll: UI.View.Scroll)
    func endDecelerating(scroll: UI.View.Scroll)
    
    func scrollToTop(scroll: UI.View.Scroll)
    
}

protocol KKScrollViewDelegate : AnyObject {
    
    func update(_ view: KKScrollView, contentSize: Size)
    
    func triggeredRefresh(_ view: KKScrollView)
    
    func beginDragging(_ view: KKScrollView)
    func dragging(_ view: KKScrollView, contentOffset: Point)
    func endDragging(_ view: KKScrollView, decelerate: Bool)
    func beginDecelerating(_ view: KKScrollView)
    func endDecelerating(_ view: KKScrollView)
    
    func scrollToTop(_ view: KKScrollView)
    
    func isDynamicSize(_ view: KKScrollView) -> Bool
    
}

public extension UI.View {
    
    final class Scroll {
        
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
        public var size: UI.Size.Dynamic = .init(.fill, .fill) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var direction: Direction = [ .vertical, .bounds ] {
            didSet {
                guard self.direction != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(direction: self.direction)
                }
            }
        }
        public var content: IUILayout? {
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
                    self.setNeedForceLayout()
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
        public var indicatorDirection: Direction = .vertical {
            didSet {
                guard self.indicatorDirection != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(indicatorDirection: self.indicatorDirection)
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
        public var refreshColor: UI.Color? {
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
        public private(set) var isDragging: Bool = false
        public private(set) var isDecelerating: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        public let onStyle: Signal.Args< Void, Bool > = .init()
        public let onBeginDragging: Signal.Empty< Void > = .init()
        public let onDragging: Signal.Empty< Void > = .init()
        public let onEndDragging: Signal.Args< Void, Bool > = .init()
        public let onBeginDecelerating: Signal.Empty< Void > = .init()
        public let onEndDecelerating: Signal.Empty< Void > = .init()
        public let onTriggeredRefresh: Signal.Empty< Void > = .init()
        public let onScrollToTop: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _contentOffset: Point = .zero
        private var _refreshColor: UI.Color?
        private var _isRefreshing: Bool = false
        private var _isLocked: Bool = false
        private var _observer: Observer< IUIScrollViewObserver > = .init()
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init() {
        }
        
        deinit {
            self._destroy()
        }
        
        public func add(observer: IUIScrollViewObserver) {
            self._observer.add(observer, priority: 0)
        }
        
        public func remove(observer: IUIScrollViewObserver) {
            self._observer.remove(observer)
        }
        
    }
    
}

private extension UI.View.Scroll {
    
    func _destroy() {
        self._reuse.destroy()
        self._animation = nil
    }
    
    func _scrollToTop() {
        self.onScrollToTop.emit()
        self._observer.notify({ $0.scrollToTop(scroll: self) })
    }
    
}

public extension UI.View.Scroll {
    
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

public extension UI.View.Scroll {
    
    func contentOffset(
        with view: IUIView,
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
        to view: IUIView,
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
            self._animation = Animation.default.run(
                .custom(
                    duration: TimeInterval(deltaContentOffset.value / velocity),
                    ease: Animation.Ease.QuadraticInOut(),
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

public extension UI.View.Scroll {
    
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
    func content(_ value: IUILayout?) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IUILayout) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IUILayout) -> Self {
        return self.content(value(self))
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
    func refreshColor(_ value: UI.Color?) -> Self {
        self.refreshColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func refreshColor(_ value: () -> UI.Color?) -> Self {
        return self.refreshColor(value())
    }

    @inlinable
    @discardableResult
    func refreshColor(_ value: (Self) -> UI.Color?) -> Self {
        return self.refreshColor(value(self))
    }
    
#endif
    
}

public extension UI.View.Scroll {
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh(_ closure: (() -> Void)?) -> Self {
        self.onTriggeredRefresh.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh(_ closure: @escaping (Self) -> Void) -> Self {
        self.onTriggeredRefresh.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onTriggeredRefresh.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop(_ closure: (() -> Void)?) -> Self {
        self.onScrollToTop.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop(_ closure: @escaping (Self) -> Void) -> Self {
        self.onScrollToTop.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onScrollToTop.link(sender, closure)
        return self
    }
    
}

extension UI.View.Scroll : IUIView {
    
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

extension UI.View.Scroll : IUIViewReusable {
    
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

extension UI.View.Scroll : IUIViewTransformable {
}

#endif

extension UI.View.Scroll : IUIViewDynamicSizeable {
}

extension UI.View.Scroll : IUIViewScrollable {
}

extension UI.View.Scroll : IUIViewColorable {
}

extension UI.View.Scroll : IUIViewAlphable {
}

extension UI.View.Scroll : IUIViewLockable {
}

extension UI.View.Scroll : KKScrollViewDelegate {
    
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
            self._observer.notify({ $0.beginDragging(scroll: self) })
        }
    }
    
    func dragging(_ view: KKScrollView, contentOffset: Point) {
        if self._contentOffset != contentOffset {
            self._contentOffset = contentOffset
            self.onDragging.emit()
            self._observer.notify({ $0.dragging(scroll: self) })
        }
    }
    
    func endDragging(_ view: KKScrollView, decelerate: Bool) {
        if self.isDragging == true {
            self.isDragging = false
            self.onEndDragging.emit(decelerate)
            self._observer.notify({ $0.endDragging(scroll: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self.onBeginDecelerating.emit()
            self._observer.notify({ $0.beginDecelerating(scroll: self) })
        }
    }
    
    func endDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self.onEndDecelerating.emit()
            self._observer.notify({ $0.endDecelerating(scroll: self) })
        }
    }
    
    func scrollToTop(_ view: KKScrollView) {
        self._scrollToTop()
    }
    
    func isDynamicSize(_ view: KKScrollView) -> Bool {
        return self.width.isStatic == true && self.height.isStatic == true
    }
    
}

public extension IUIView where Self == UI.View.Scroll {
    
    @inlinable
    static func scroll(_ direction: UI.View.Scroll.Direction) -> Self {
        return .init().direction(direction)
    }
    
}
