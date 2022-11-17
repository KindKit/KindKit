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
    
    func update(_ view: KKScrollView, contentSize: SizeFloat)
    
    func triggeredRefresh(_ view: KKScrollView)
    
    func beginDragging(_ view: KKScrollView)
    func dragging(_ view: KKScrollView, contentOffset: PointFloat)
    func endDragging(_ view: KKScrollView, decelerate: Bool)
    func beginDecelerating(_ view: KKScrollView)
    func endDecelerating(_ view: KKScrollView)
    
    func scrollToTop(_ view: KKScrollView)
    
    func isDynamicSize(_ view: KKScrollView) -> Bool
    
}

public extension UI.View {
    
    final class Scroll {
        
        public private(set) weak var appearedLayout: IUILayout?
        public weak var appearedItem: UI.Layout.Item?
        public var size: UI.Size.Dynamic = .init(width: .fill, height: .fill) {
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
                self.content?.view = nil
            }
            didSet {
                guard self.content !== oldValue else { return }
                self.content?.view = self
                if self.isLoaded == true {
                    self._view.update(content: self.content)
                }
            }
        }
        public private(set) var contentSize: SizeFloat = .zero
        public var contentInset: InsetFloat = .zero {
            didSet {
                guard self.contentInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(contentInset: self.contentInset)
                }
            }
        }
        public var contentOffset: PointFloat {
            set {
                guard self._contentOffset != newValue else { return }
                self._contentOffset = newValue
                if self.isLoaded == true {
                    self._view.update(contentOffset: newValue, normalized: false)
                }
            }
            get { self._contentOffset }
        }
        public var visibleInset: InsetFloat = .zero {
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
        public var alpha: Float = 1 {
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
        private var _contentOffset: PointFloat = .zero
        private var _refreshColor: UI.Color?
        private var _isRefreshing: Bool = false
        private var _isLocked: Bool = false
        private var _observer: Observer< IUIScrollViewObserver > = .init()
        private var _animation: IAnimationTask? {
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
    
    func contentOffset(
        with view: IUIView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) -> PointFloat? {
        guard let item = view.appearedItem else { return nil }
        let contentInset = self.contentInset
        let contentSize = self.contentSize
        let visibleSize = self.bounds.size
        let itemFrame = item.frame
        let x: Float
        switch horizontal {
        case .leading: x = -contentInset.left + itemFrame.x
        case .center: x = -contentInset.left + ((itemFrame.x + (itemFrame.width / 2)) - ((visibleSize.width - contentInset.right) / 2))
        case .trailing: x = ((itemFrame.x + itemFrame.width) - visibleSize.width) + contentInset.right
        }
        let y: Float
        switch vertical {
        case .leading: y = -contentInset.top + itemFrame.y
        case .center: y = -contentInset.top + ((itemFrame.y + (itemFrame.size.height / 2)) - ((visibleSize.height - contentInset.bottom) / 2))
        case .trailing: y = ((itemFrame.y + itemFrame.size.height) - visibleSize.height) + contentInset.bottom
        }
        let lowerX = -contentInset.left
        let lowerY = -contentInset.top
        let upperX = (contentSize.width - visibleSize.width) + contentInset.right
        let upperY = (contentSize.height - visibleSize.height) + contentInset.bottom
        return PointFloat(
            x: max(lowerX, min(x, upperX)),
            y: max(lowerY, min(y, upperY))
        )
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
    
    func scrollToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        let contentInset = self.contentInset
        let beginContentOffset = self.contentOffset
        let endContentOffset = PointFloat(x: -contentInset.left, y: -contentInset.top)
        let deltaContentOffset = beginContentOffset.distance(endContentOffset).real.abs
        if animated == true && deltaContentOffset > 0 {
            let velocity = max(self.bounds.width, self.bounds.height) * 5
            self._animation = Animation.default.run(
                duration: TimeInterval(deltaContentOffset / velocity),
                ease: Animation.Ease.QuadraticInOut(),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    let contentOffset = beginContentOffset.lerp(endContentOffset, progress: progress.value)
                    self.contentOffset(contentOffset)
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._animation = nil
                    self._scrollToTop()
                    completion?()
                }
            )
        } else {
            self.contentOffset = PointFloat(x: -contentInset.left, y: -contentInset.top)
            self._scrollToTop()
            completion?()
        }
    }
    
}

public extension UI.View.Scroll {
    
    var estimatedContentOffset: PointFloat {
        let size = self.bounds.size
        let contentOffset = self.contentOffset
        let contentSize = self.contentSize
        let contentInset = self.contentInset
        return PointFloat(
            x: (contentInset.left + contentSize.width + contentInset.right) - (contentOffset.x + size.width),
            y: (contentInset.top + contentSize.height + contentInset.bottom) - (contentOffset.y + size.height)
        )
    }
    
    @discardableResult
    func contentOffset(_ value: PointFloat, normalized: Bool = false) -> Self {
        self._contentOffset = value
        if self.isLoaded == true {
            self._view.update(contentOffset: value, normalized: normalized)
        }
        return self
    }
    
    @discardableResult
    func content(_ value: IUILayout) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func direction(_ value: Direction) -> Self {
        self.direction = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicatorDirection(_ value: Direction) -> Self {
        self.indicatorDirection = value
        return self
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
    func refreshColor(_ value: UI.Color?) -> Self {
        self.refreshColor = value
        return self
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
    func onTriggeredRefresh(_ closure: ((Self) -> Void)?) -> Self {
        self.onTriggeredRefresh.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
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
    func onScrollToTop(_ closure: ((Self) -> Void)?) -> Self {
        self.onScrollToTop.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
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
    
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(
            available: available,
            sizeWithWidth: {
                guard let content = self.content else { return .init(width: $0, height: 0) }
                return content.size(available: .init(width: $0, height: available.height))
            },
            sizeWithHeight: {
                guard let content = self.content else { return .init(width: 0, height: $0) }
                return content.size(available: .init(width: available.width, height: $0))
            },
            size: {
                guard let content = self.content else { return .zero }
                return content.size(available: available)
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
    
    func update(_ view: KKScrollView, contentSize: SizeFloat) {
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
    
    func dragging(_ view: KKScrollView, contentOffset: PointFloat) {
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
