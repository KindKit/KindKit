//
//  KindKit
//

import KindAnimation
import KindEvent
import KindGraphics
import KindLayout
import KindTime
import KindMonadicMacro

protocol KKScrollViewDelegate : AnyObject {
    
    func kk_update(_ view: KKScrollView, contentOffset: Point)
    func kk_update(_ view: KKScrollView, zoom: Double)
    
    func kk_beginDragging(_ view: KKScrollView)
    func kk_endDragging(_ view: KKScrollView, decelerate: Bool)
    func kk_beginDecelerating(_ view: KKScrollView)
    func kk_endDecelerating(_ view: KKScrollView)
    
    func kk_beginZooming(_ view: KKScrollView)
    func kk_endZooming(_ view: KKScrollView)
    
    func kk_scrollToTop(_ view: KKScrollView)
    
    func kk_triggeredRefresh(_ view: KKScrollView)
    
}

@KindMonadic
public final class ScrollView< LayoutType : ILayout > : IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportScroll, IViewSupportZoom, IViewSupportEnable, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self._layout.manager.available = self.size
            self.updateLayout(force: true)
        }
    }
    
    @KindMonadicProperty(default: EmptyLayout.self)
    public var content: LayoutType {
        didSet {
            guard self.content !== oldValue else { return }
            self._layout.manager.content = self.content
        }
    }
    
    public var contentInset: Inset = .zero {
        didSet {
            guard self.contentInset != oldValue else { return }
            self._updateAdjustmentInset()
        }
    }
    
    public var contentOffset: Point {
        set {
            guard self._layout.manager.viewOrigin != newValue else { return }
            self._layout.manager.viewOrigin = newValue
            if self.isDragging == true {
                self.onDragging.emit()
            } else if self.isLoaded == true {
                self._layout.view.kk_update(contentOffset: newValue)
            }
        }
        get { self._layout.manager.viewOrigin }
    }
    
    public var contentSize: Size = .zero {
        didSet {
            guard self.contentSize != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(contentSize: self.contentSize)
            }
            self._updateZoomingInset()
        }
    }
    
    public var zoom: Double = 1.0 {
        didSet {
            guard self.zoom != oldValue else { return }
            if self.isZooming == true {
                self.onZooming.emit()
            } else if self.isLoaded == true {
                self._layout.view.kk_update(zoom: self.zoom, limit: self.zoomLimit)
            }
            self._updateZoomingInset()
        }
    }
    
    public var zoomLimit: Range< Double > = 1.0 ..< 1.0 {
        didSet {
            guard self.zoomLimit != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(zoom: self.zoom, limit: self.zoomLimit)
            }
            self._updateZoomingInset()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(enabled: self.isEnabled)
            }
        }
    }
    
    public var color: Color = .clear {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(color: self.color)
            }
        }
    }
    
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(alpha: self.alpha)
            }
        }
    }
    
    @KindMonadicProperty
    public var bounce: ScrollBounce = [ .vertical, .zoom ] {
        didSet {
            guard self.bounce != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(bounce: self.bounce)
            }
        }
    }
    
    @KindMonadicProperty
    public var indicatorDirection: ScrollDirection = .vertical {
        didSet {
            guard self.indicatorDirection != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(indicatorDirection: self.indicatorDirection)
            }
        }
    }
    
#if os(iOS)
    
    @KindMonadicProperty
    public var delaysContentTouches: Bool = true {
        didSet {
            guard self.delaysContentTouches != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(delaysContentTouches: self.delaysContentTouches)
            }
        }
    }
    
    @KindMonadicProperty
    public var refreshColor: Color? {
        set {
            guard self._refreshColor != newValue else { return }
            self._refreshColor = newValue
            if self.isLoaded == true {
                self._layout.view.kk_update(refreshColor: self._refreshColor)
            }
        }
        get { self._refreshColor }
    }
    
    @KindMonadicProperty
    public var isRefreshing: Bool {
        set {
            guard self._isRefreshing != newValue else { return }
            self._isRefreshing = newValue
            if self.isLoaded == true {
                self._layout.view.kk_update(isRefreshing: self._isRefreshing)
            }
        }
        get { self._isRefreshing }
    }
    
#endif
    
    public private(set) var isDragging: Bool = false
    public private(set) var isDecelerating: Bool = false
    public private(set) var isZooming: Bool = false
    
    public var adjustmentInset: Inset = .zero {
        didSet {
            guard self.adjustmentInset != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(adjustmentInset: self.adjustmentInset)
            }
            let deltaInset = self.adjustmentInset - oldValue
            let oldContentOffset = self.contentOffset
            let newContentOffset = Point(
                x: max(-self.adjustmentInset.left, oldContentOffset.x - deltaInset.left),
                y: max(-self.adjustmentInset.top, oldContentOffset.y - deltaInset.top)
            )
            self.contentOffset = newContentOffset
            if self.size.isStatic == false {
                self.updateLayout(force: true)
            }
        }
    }
    
    public let onBeginDragging = Signal< Void, Void >()
    
    public let onDragging = Signal< Void, Void >()
    
    public let onEndDragging = Signal< Void, Bool >()
    
    public let onBeginDecelerating = Signal< Void, Void >()
    
    public let onEndDecelerating = Signal< Void, Void >()
    
    public let onBeginZooming = Signal< Void, Void >()
    
    public let onZooming = Signal< Void, Void >()
    
    public let onEndZooming = Signal< Void, Void >()
    
    @KindMonadicSignal
    public let onScrollToTop = Signal< Void, Void >()
    
    @KindMonadicSignal
    public let onTriggeredRefresh = Signal< Void, Void >()
    
    var zoomingInset: Inset = .zero {
        didSet {
            guard self.zoomingInset != oldValue else { return }
            self._updateAdjustmentInset()
        }
    }
    
    private var _layout: ReuseRootLayoutItem< Reusable, LayoutType >!
    private var _refreshColor: KindGraphics.Color?
    private var _isRefreshing: Bool = false
    private var _animation: ICancellable?
    
    var holder: IHolder? {
        set { self._layout.manager.holder = newValue }
        get { self._layout.manager.holder }
    }
    
    public init(
        _ content: LayoutType
    ) {
        self.content = content
        
        self._layout = .init(self)
        
        self._layout.manager
            .content(content)
            .onContentSize(self, { $0._onContentSize() })
        
#if os(iOS)
        VirtualInput.Listener.default.onWillShow(self, { $0._onWillShow($1) })
#endif
    }
    
    public convenience init< InitType: ILayout >(
        _ content: InitType
    ) where ContentType == AnyLayout {
        self.init(.init(content))
    }
    
    public convenience init(
        _ view: any IView
    ) where ContentType == AnyViewLayout {
        self.init(.init(view))
    }
    
    public convenience init< ViewType: IView >(
        _ view: ViewType
    ) where ContentType == ViewLayout< ViewType > {
        self.init(.init(view))
    }
    
    deinit {
#if os(iOS)
        VirtualInput.Listener.default.onWillShow(remove: self)
#endif
        
        self._animation?.cancel()
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self._layout.sizeOf(request)
    }
    
}

private extension ScrollView {
    
#if os(iOS)
    
    func _onWillShow(_ info: VirtualInput.Listener.Info) {
        guard self.isLoaded == true else { return }
        guard let view = self.handle.kk_firstResponder else { return }
        self.scroll(to: view, horizontal: .center, vertical: .center, duration: info.duration)
    }
    
#endif
    
    func _updateZoomingInset() {
        if self.zoomLimit.lowerBound != self.zoomLimit.upperBound {
            let contentSize = self._layout.manager.contentSize
            let viewSize = self._layout.manager.viewSize
            let hp = (viewSize.width > contentSize.width) ? (viewSize.width - contentSize.width) / 2 : 0
            let vp = (viewSize.height > contentSize.height) ? (viewSize.height - contentSize.height) / 2 : 0
            self.zoomingInset = .init(
                horizontal: hp,
                vertical: vp
            )
        } else {
            self.zoomingInset = .zero
        }
    }
    
    func _updateAdjustmentInset() {
        let contentInset = self.contentInset
        let zoomingInset = self.zoomingInset
        self.adjustmentInset = .init(
            top: max(zoomingInset.top, contentInset.top),
            left: max(zoomingInset.left, contentInset.left),
            right: max(zoomingInset.right, contentInset.right),
            bottom: max(zoomingInset.bottom, contentInset.bottom)
        )
    }
    
    func _onContentSize() {
        self.contentSize = self._layout.manager.contentSize
    }
    
}

public extension ScrollView {
    
    var estimatedContentOffset: Point {
        let viewSize = self.bounds.size
        let contentOffset = self.contentOffset
        let contentSize = self.contentSize
        let adjustmentInset = self.adjustmentInset
        return Point(
            x: (adjustmentInset.left + contentSize.width + adjustmentInset.right) - (contentOffset.x + viewSize.width),
            y: (adjustmentInset.top + contentSize.height + adjustmentInset.bottom) - (contentOffset.y + viewSize.height)
        )
    }
    
}

public extension ScrollView {
    
    func contentOffset(
        with view: any IView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) -> Point? {
        guard self.isLoaded == true else {
            return nil
        }
        return self.contentOffset(
            with: view.convert(view.bounds, to: self),
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
        return self.contentOffset(
            with: .init(view.convert(view.bounds, to: self.handle)),
            horizontal: horizontal,
            vertical: vertical
        )
    }
    
    func contentOffset(
        with target: Rect,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) -> Point? {
        let inset = self.adjustmentInset
        let contentSize = self.contentSize
        let visibleSize = self.bounds.size
        let x: Double
        if contentSize.width > visibleSize.width {
            switch horizontal {
            case .leading: x = -inset.left + target.minX
            case .center: x = -inset.left + (target.midX - ((visibleSize.width - inset.right) / 2))
            case .trailing: x = (target.maxX - visibleSize.width) + inset.right
            }
        } else {
            x = -inset.left + target.x
        }
        let y: Double
        if contentSize.height > visibleSize.height {
            switch vertical {
            case .leading: y = -inset.top + target.minY
            case .center: y = -inset.top + (target.midY - ((visibleSize.height - inset.bottom) / 2))
            case .trailing: y = (target.maxY - visibleSize.height) + inset.bottom
            }
        } else {
            y = -inset.top + target.y
        }
        let lowerX = -inset.left
        let lowerY = -inset.top
        let upperX = (contentSize.width - visibleSize.width) + inset.right
        let upperY = (contentSize.height - visibleSize.height) + inset.bottom
        return .init(
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
    
    func scroll(
        to view: any IView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.contentOffset = to
    }
    
    func scroll(
        to view: NativeView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.contentOffset = to
    }
    
    func scroll(
        to view: any IView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment,
        velocity: Double,
        completion: (() -> Void)? = nil
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.scroll(to: to, velocity: velocity, completion: completion)
    }
    
    func scroll(
        to view: NativeView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment,
        velocity: Double,
        completion: (() -> Void)? = nil
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.scroll(to: to, velocity: velocity, completion: completion)
    }
    
    func scroll< DurationType : IUnit >(
        to view: any IView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment,
        duration: Interval< DurationType >,
        completion: (() -> Void)? = nil
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.scroll(to: to, duration: duration, completion: completion)
    }
    
    func scroll< DurationType : IUnit >(
        to view: NativeView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment,
        duration: Interval< DurationType >,
        completion: (() -> Void)? = nil
    ) {
        guard let to = self.contentOffset(with: view, horizontal: horizontal, vertical: vertical) else {
            return
        }
        self.scroll(to: to, duration: duration, completion: completion)
    }
    
    func scrollToTop(
        velocity: Double,
        completion: (() -> Void)? = nil
    ) {
        let inset = self.adjustmentInset
        self.scroll(
            to: .init(x: -inset.left, y: -inset.top),
            velocity: velocity,
            completion: { [weak self] in
                self?.onScrollToTop.emit()
                completion?()
            }
        )
    }
    
    func scroll(
        to: Point,
        velocity: Double,
        completion: (() -> Void)? = nil
    ) {
        let from = self.contentOffset
        let delta = from.length(to).abs
        if delta > .zero {
            let duration = SecondsInterval(delta.value / velocity)
            self.scroll(to: to, duration: duration, completion: completion)
        } else {
            completion?()
        }
    }
    
    func scroll< DurationType : IUnit >(
        to: Point,
        duration: Interval< DurationType >,
        completion: (() -> Void)? = nil
    ) {
        if duration > .zero {
            self._animation = KindAnimation.default.run(
                PropertyAction(duration: duration, target: self, path: \.contentOffset, to: to)
                    .onFinish(self, { owner, _ in
                        owner._animation = nil
                        completion?()
                    })
            )
        } else {
            self.contentOffset = to
            completion?()
        }
    }
    
}

extension ScrollView : KKScrollViewDelegate {
    
    func kk_update(_ view: KKScrollView, zoom: Double) {
        self.zoom = zoom
    }
    
    func kk_update(_ view: KKScrollView, contentOffset: Point) {
        self.contentOffset = contentOffset
    }
    
    func kk_beginDragging(_ view: KKScrollView) {
        if self.isDragging == false {
            self.isDragging = true
            self.onBeginDragging.emit()
        }
    }
    
    func kk_endDragging(_ view: KKScrollView, decelerate: Bool) {
        if self.isDragging == true {
            self.isDragging = false
            self.onEndDragging.emit(decelerate)
        }
    }
    
    func kk_beginDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self.onBeginDecelerating.emit()
        }
    }
    
    func kk_endDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self.onEndDecelerating.emit()
        }
    }
    
    func kk_beginZooming(_ view: KKScrollView) {
        if self.isZooming == false {
            self.isZooming = true
            self.onBeginZooming.emit()
        }
    }
    
    func kk_endZooming(_ view: KKScrollView) {
        if self.isZooming == true {
            self.isZooming = false
            self.onEndZooming.emit()
        }
    }
    
    func kk_scrollToTop(_ view: KKScrollView) {
        self.onScrollToTop.emit()
    }
    
    func kk_triggeredRefresh(_ view: KKScrollView) {
        self.onTriggeredRefresh.emit()
    }
    
}
