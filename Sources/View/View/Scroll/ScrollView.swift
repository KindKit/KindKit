//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitObserver

protocol ScrollViewDelegate : AnyObject {
    
    func _update(contentSize: SizeFloat)
    
    func _triggeredRefresh()

    func _beginScrolling()
    func _scrolling(contentOffset: PointFloat)
    func _endScrolling(decelerate: Bool)
    func _beginDecelerating()
    func _endDecelerating()
    
    func _scrollToTop()
    
    func _isDynamicSize() -> Bool
    
}

public final class ScrollView< Layout : ILayout > : IScrollView {
    
    public private(set) unowned var layout: ILayout?
    public unowned var item: LayoutItem?
    public var native: NativeView {
        return self._view
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return RectFloat(self._view.bounds)
    }
    public private(set) var isVisible: Bool
    public var isHidden: Bool {
        didSet(oldValue) {
            guard self.isHidden != oldValue else { return }
            self.setNeedForceLayout()
        }
    }
    public var width: DynamicSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: DynamicSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var direction: ScrollViewDirection {
        didSet(oldValue) {
            guard self.direction != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(direction: self.direction)
        }
    }
    public var indicatorDirection: ScrollViewDirection {
        didSet(oldValue) {
            guard self.indicatorDirection != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(indicatorDirection: self.indicatorDirection)
        }
    }
    public var visibleInset: InsetFloat {
        didSet(oldValue) {
            guard self.visibleInset != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(visibleInset: self.visibleInset)
        }
    }
    public var contentInset: InsetFloat {
        didSet(oldValue) {
            guard self.contentInset != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(contentInset: self.contentInset)
        }
    }
    public var contentOffset: PointFloat {
        set(value) {
            self._contentOffset = value
            if self.isLoaded == true {
                self._view.update(contentOffset: value, normalized: false)
            }
        }
        get { return self._contentOffset }
    }
    public private(set) var contentSize: SizeFloat
    public var contentLayout: Layout {
        willSet {
            self.contentLayout.view = nil
        }
        didSet(oldValue) {
            self.contentLayout.view = self
            guard self.isLoaded == true else { return }
            self._view.update(contentLayout: self.contentLayout)
        }
    }
    public private(set) var isScrolling: Bool
    public private(set) var isDecelerating: Bool
    #if os(iOS)
    @available(iOS 10.0, *)
    public var refreshColor: Color? {
        set(value) {
            guard self._refreshColor != value else { return }
            self._refreshColor = value
            guard self.isLoaded == true else { return }
            self._view.update(refreshColor: self._refreshColor)
        }
        get { return self._refreshColor }
    }
    @available(iOS 10.0, *)
    public var isRefreshing: Bool {
        set(value) {
            guard self._isRefreshing != value else { return }
            self._isRefreshing = value
            guard self.isLoaded == true else { return }
            self._view.update(isRefreshing: self._isRefreshing)
        }
        get { return self._isRefreshing }
    }
    #endif
    public var color: Color? {
        didSet(oldValue) {
            guard self.color != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet(oldValue) {
            guard self.cornerRadius != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
            self._view.updateShadowPath()
        }
    }
    public var border: ViewBorder {
        didSet(oldValue) {
            guard self.border != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var shadow: ViewShadow? {
        didSet(oldValue) {
            guard self.shadow != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
            self._view.updateShadowPath()
        }
    }
    public var alpha: Float {
        didSet(oldValue) {
            guard self.alpha != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _contentOffset: PointFloat
    private var _refreshColor: Color?
    private var _isRefreshing: Bool
    private var _observer: Observer< IScrollViewObserver >
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onTriggeredRefresh: (() -> Void)?
    private var _onBeginScrolling: (() -> Void)?
    private var _onScrolling: (() -> Void)?
    private var _onEndScrolling: ((_ decelerate: Bool) -> Void)?
    private var _onBeginDecelerating: (() -> Void)?
    private var _onEndDecelerating: (() -> Void)?
    private var _onScrollToTop: (() -> Void)?
    
    public init(
        width: DynamicSizeBehaviour = .static(.fill),
        height: DynamicSizeBehaviour = .static(.fill),
        direction: ScrollViewDirection = [ .vertical, .bounds ],
        indicatorDirection: ScrollViewDirection = [],
        visibleInset: InsetFloat = .zero,
        contentInset: InsetFloat = .zero,
        contentOffset: PointFloat = .zero,
        contentLayout: Layout,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.direction = direction
        self.indicatorDirection = indicatorDirection
        self.visibleInset = visibleInset
        self.contentInset = contentInset
        self.contentLayout = contentLayout
        self.contentSize = .zero
        self.isScrolling = false
        self.isDecelerating = false
        self._isRefreshing = false
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
        self._observer = Observer()
        self._contentOffset = contentOffset
        self.contentLayout.view = self
        self._reuse.configure(owner: self)
    }
    
    #if os(iOS)
    
    @available(iOS 10.0, *)
    public init(
        width: DynamicSizeBehaviour = .static(.fill),
        height: DynamicSizeBehaviour = .static(.fill),
        direction: ScrollViewDirection = [ .vertical, .bounds ],
        indicatorDirection: ScrollViewDirection = [],
        visibleInset: InsetFloat = .zero,
        contentInset: InsetFloat = .zero,
        contentOffset: PointFloat = .zero,
        contentLayout: Layout,
        refreshColor: Color? = nil,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.direction = direction
        self.indicatorDirection = indicatorDirection
        self.visibleInset = visibleInset
        self.contentInset = contentInset
        self.contentLayout = contentLayout
        self._refreshColor = refreshColor
        self.contentSize = .zero
        self.isScrolling = false
        self.isDecelerating = false
        self._isRefreshing = false
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
        self._observer = Observer()
        self._contentOffset = contentOffset
        self.contentLayout.view = self
        self._reuse.configure(owner: self)
    }
    
    #endif
    
    deinit {
        self._reuse.destroy()
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return DynamicSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height,
            sizeWithWidth: { self.contentLayout.size(available: Size(width: $0, height: available.height)) },
            sizeWithHeight: { self.contentLayout.size(available: Size(width: available.width, height: $0)) },
            size: { self.contentLayout.size(available: available) }
        )
    }
    
    public func appear(to layout: ILayout) {
        self.layout = layout
        self._onAppear?()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.layout = nil
        self._onDisappear?()
    }
    
    public func visible() {
        self.isVisible = true
        self._onVisible?()
    }
    
    public func visibility() {
        self._onVisibility?()
    }
    
    public func invisible() {
        self.isVisible = false
        self._onInvisible?()
    }
    
    public func add(observer: IScrollViewObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    public func remove(observer: IScrollViewObserver) {
        self._observer.remove(observer)
    }
    
    public func contentOffset(
        with view: IView,
        horizontal: ScrollViewScrollAlignment,
        vertical: ScrollViewScrollAlignment
    ) -> PointFloat? {
        guard let item = view.item else { return nil }
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
    
    @discardableResult
    public func contentOffset(_ value: PointFloat, normalized: Bool) -> Self {
        self._contentOffset = value
        if self.isLoaded == true {
            self._view.update(contentOffset: value, normalized: normalized)
        }
        return self
    }
    
    @discardableResult
    public func contentLayout(_ value: Layout) -> Self {
        self.contentLayout = value
        return self
    }
    
    #if os(iOS)
    
    @available(iOS 10.0, *)
    @discardableResult
    public func beginRefresh() -> Self {
        self.isRefreshing = true
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func endRefresh() -> Self {
        self.isRefreshing = false
        return self
    }
    
    #endif
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._onAppear = value
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._onDisappear = value
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._onVisible = value
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._onVisibility = value
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._onInvisible = value
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func onTriggeredRefresh(_ value: (() -> Void)?) -> Self {
        self._onTriggeredRefresh = value
        return self
    }
    
    @discardableResult
    public func onBeginScrolling(_ value: (() -> Void)?) -> Self {
        self._onBeginScrolling = value
        return self
    }
    
    @discardableResult
    public func onScrolling(_ value: (() -> Void)?) -> Self {
        self._onScrolling = value
        return self
    }
    
    @discardableResult
    public func onEndScrolling(_ value: ((_ decelerate: Bool) -> Void)?) -> Self {
        self._onEndScrolling = value
        return self
    }
    
    @discardableResult
    public func onBeginDecelerating(_ value: (() -> Void)?) -> Self {
        self._onBeginDecelerating = value
        return self
    }
    
    @discardableResult
    public func onEndDecelerating(_ value: (() -> Void)?) -> Self {
        self._onEndDecelerating = value
        return self
    }
    
    @discardableResult
    public func onScrollToTop(_ value: (() -> Void)?) -> Self {
        self._onScrollToTop = value
        return self
    }
    
    public func scrollToTop(animated: Bool, completion: (() -> Void)?) {
        let contentInset = self.contentInset
        let beginContentOffset = self.contentOffset
        let endContentOffset = PointFloat(x: -contentInset.left, y: -contentInset.top)
        let deltaContentOffset = beginContentOffset.distance(endContentOffset).real.abs
        if animated == true && deltaContentOffset > 0 {
            let velocity = max(self.bounds.width, self.bounds.height) * 5
            Animation.default.run(
                duration: TimeInterval(deltaContentOffset / velocity),
                ease: Animation.Ease.QuadraticInOut(),
                processing: { [unowned self] progress in
                    let contentOffset = beginContentOffset.lerp(endContentOffset, progress: progress.value)
                    self.contentOffset(contentOffset)
                },
                completion: { [unowned self] in
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

extension ScrollView : ScrollViewDelegate {
    
    func _update(contentSize: SizeFloat) {
        self.contentSize = contentSize
    }
    
    func _triggeredRefresh() {
        self._onTriggeredRefresh?()
    }
    
    func _beginScrolling() {
        if self.isScrolling == false {
            self.isScrolling = true
            self._onBeginScrolling?()
            self._observer.notify({ $0.beginScrolling(scrollView: self) })
        }
    }
    
    func _scrolling(contentOffset: PointFloat) {
        if self._contentOffset != contentOffset {
            self._contentOffset = contentOffset
            self._onScrolling?()
            self._observer.notify({ $0.scrolling(scrollView: self) })
        }
    }
    
    func _endScrolling(decelerate: Bool) {
        if self.isScrolling == true {
            self.isScrolling = false
            self._onEndScrolling?(decelerate)
            self._observer.notify({ $0.endScrolling(scrollView: self, decelerate: decelerate) })
        }
    }
    
    func _beginDecelerating() {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self._onBeginDecelerating?()
            self._observer.notify({ $0.beginDecelerating(scrollView: self) })
        }
    }
    
    func _endDecelerating() {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self._onEndDecelerating?()
            self._observer.notify({ $0.endDecelerating(scrollView: self) })
        }
    }
    
    func _scrollToTop() {
        self._onScrollToTop?()
        self._observer.notify({ $0.scrollToTop(scrollView: self) })
    }
    
    func _isDynamicSize() -> Bool {
        switch (self.width, self.height) {
        case (.static, .static): return false
        case (.static, .morph): return true
        case (.static, .fit): return true
        case (.morph, .static): return true
        case (.morph, .morph): return true
        case (.morph, .fit): return true
        case (.fit, .static): return true
        case (.fit, .morph): return true
        case (.fit, .fit): return true
        }
    }
    
}
