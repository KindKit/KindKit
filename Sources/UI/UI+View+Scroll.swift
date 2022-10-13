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

    final class Scroll : IUIView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var native: NativeView {
            return self._view
        }
        public var isLoaded: Bool {
            return self._reuse.isLoaded
        }
        public var bounds: RectFloat {
            guard self.isLoaded == true else { return .zero }
            return Rect(self._view.bounds)
        }
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
            set { self._reuse.unloadBehaviour = newValue }
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set { self._reuse.cache = newValue }
            get { return self._reuse.cache }
        }
        public var reuseName: String? {
            set { self._reuse.name = newValue }
            get { return self._reuse.name }
        }
        public var width: UI.Size.Dynamic = .fill {
            didSet {
                guard self.width != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fill {
            didSet {
                guard self.height != oldValue else { return }
                self.setNeedForceLayout()
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
            get { return self._isLocked }
        }
        public var color: UI.Color? = nil {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(shadow: self.shadow)
                }
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
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
#endif
        public var visibleInset: InsetFloat = .zero {
            didSet {
                guard self.visibleInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(visibleInset: self.visibleInset)
                }
            }
        }
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
            get { return self._contentOffset }
        }
        public private(set) var contentSize: SizeFloat = .zero
        public var content: IUILayout {
            willSet {
                self.content.view = nil
            }
            didSet {
                self.content.view = self
                if self.isLoaded == true {
                    self._view.update(content: self.content)
                }
            }
        }
        public private(set) var isDragging: Bool = false
        public private(set) var isDecelerating: Bool = false
    #if os(iOS)
        public var refreshColor: UI.Color? {
            set {
                guard self._refreshColor != newValue else { return }
                self._refreshColor = newValue
                if self.isLoaded == true {
                    self._view.update(refreshColor: self._refreshColor)
                }
            }
            get { return self._refreshColor }
        }
        public var isRefreshing: Bool {
            set {
                guard self._isRefreshing != newValue else { return }
                self._isRefreshing = newValue
                if self.isLoaded == true {
                    self._view.update(isRefreshing: self._isRefreshing)
                }
            }
            get { return self._isRefreshing }
        }
    #endif
        public var onAppear: ((UI.View.Scroll) -> Void)?
        public var onDisappear: ((UI.View.Scroll) -> Void)?
        public var onVisible: ((UI.View.Scroll) -> Void)?
        public var onVisibility: ((UI.View.Scroll) -> Void)?
        public var onInvisible: ((UI.View.Scroll) -> Void)?
        public var onChangeStyle: ((UI.View.Scroll, Bool) -> Void)?
        public var onTriggeredRefresh: ((UI.View.Scroll) -> Void)?
        public var onBeginDragging: ((UI.View.Scroll) -> Void)?
        public var onDragging: ((UI.View.Scroll) -> Void)?
        public var onEndDragging: ((UI.View.Scroll, Bool) -> Void)?
        public var onBeginDecelerating: ((UI.View.Scroll) -> Void)?
        public var onEndDecelerating: ((UI.View.Scroll) -> Void)?
        public var onScrollToTop: ((UI.View.Scroll) -> Void)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _contentOffset: PointFloat = .zero
        private var _refreshColor: UI.Color?
        private var _isRefreshing: Bool = false
        private var _isLocked: Bool = false
        private var _observer: Observer< IUIScrollViewObserver >
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            _ content: IUILayout
        ) {
            self.content = content
            self._observer = Observer()
            self._contentOffset = contentOffset
            self.content.view = self
        }
        
        public convenience init(
            content: IUILayout,
            configure: (UI.View.Scroll) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
        deinit {
            self._destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Dynamic.apply(
                available: available,
                width: self.width,
                height: self.height,
                sizeWithWidth: { self.content.size(available: Size(width: $0, height: available.height)) },
                sizeWithHeight: { self.content.size(available: Size(width: available.width, height: $0)) },
                size: { self.content.size(available: available) }
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.appearedLayout = layout
            self.onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.appearedLayout = nil
            self.onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self.onVisible?(self)
        }
        
        public func visibility() {
            self.onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self.onInvisible?(self)
        }
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self.onChangeStyle?(self, userInteraction)
        }
        
        public func add(observer: IUIScrollViewObserver) {
            self._observer.add(observer, priority: 0)
        }
        
        public func remove(observer: IUIScrollViewObserver) {
            self._observer.remove(observer)
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
    
    @inlinable
    @discardableResult
    func visibleInset(_ value: InsetFloat) -> Self {
        self.visibleInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
#if os(iOS)
    
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
    func onAppear(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((UI.View.Scroll, Bool) -> Void)?) -> Self {
        self.onChangeStyle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggeredRefresh(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onTriggeredRefresh = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onBeginDragging = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onDragging = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ value: ((UI.View.Scroll, Bool) -> Void)?) -> Self {
        self.onEndDragging = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onBeginDecelerating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onEndDecelerating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onScrollToTop(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
        self.onScrollToTop = value
        return self
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
                processing: { [unowned self] progress in
                    let contentOffset = beginContentOffset.lerp(endContentOffset, progress: progress.value)
                    self.contentOffset(contentOffset)
                },
                completion: { [unowned self] in
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

private extension UI.View.Scroll {
    
    func _destroy() {
        self._reuse.destroy()
        self._animation = nil
    }

    func _scrollToTop() {
        self.onScrollToTop?(self)
        self._observer.notify({ $0.scrollToTop(scroll: self) })
    }

}

extension UI.View.Scroll : KKScrollViewDelegate {
    
    
    func update(_ view: KKScrollView, contentSize: SizeFloat) {
        self.contentSize = contentSize
    }
    
    func triggeredRefresh(_ view: KKScrollView) {
        self.onTriggeredRefresh?(self)
    }
    
    func beginDragging(_ view: KKScrollView) {
        if self.isDragging == false {
            self.isDragging = true
            self.onBeginDragging?(self)
            self._observer.notify({ $0.beginDragging(scroll: self) })
        }
    }
    
    func dragging(_ view: KKScrollView, contentOffset: PointFloat) {
        if self._contentOffset != contentOffset {
            self._contentOffset = contentOffset
            self.onDragging?(self)
            self._observer.notify({ $0.dragging(scroll: self) })
        }
    }
    
    func endDragging(_ view: KKScrollView, decelerate: Bool) {
        if self.isDragging == true {
            self.isDragging = false
            self.onEndDragging?(self, decelerate)
            self._observer.notify({ $0.endDragging(scroll: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self.onBeginDecelerating?(self)
            self._observer.notify({ $0.beginDecelerating(scroll: self) })
        }
    }
    
    func endDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self.onEndDecelerating?(self)
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
