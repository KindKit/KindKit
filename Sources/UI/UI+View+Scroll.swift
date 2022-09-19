//
//  KindKit
//

import Foundation

public protocol IUIScrollViewObserver : AnyObject {
    
    func beginScrolling(scrollView: UI.View.Scroll)
    func scrolling(scrollView: UI.View.Scroll)
    func endScrolling(scrollView: UI.View.Scroll, decelerate: Bool)
    func beginDecelerating(scrollView: UI.View.Scroll)
    func endDecelerating(scrollView: UI.View.Scroll)
    
    func scrollToTop(scrollView: UI.View.Scroll)
    
}

protocol KKScrollViewDelegate : AnyObject {
    
    func update(_ view: KKScrollView, contentSize: SizeFloat)
    
    func triggeredRefresh(_ view: KKScrollView)
    
    func beginScrolling(_ view: KKScrollView)
    func scrolling(_ view: KKScrollView, contentOffset: PointFloat)
    func endScrolling(_ view: KKScrollView, decelerate: Bool)
    func beginDecelerating(_ view: KKScrollView)
    func endDecelerating(_ view: KKScrollView)
    
    func scrollToTop(_ view: KKScrollView)
    
    func isDynamicSize(_ view: KKScrollView) -> Bool
    
}

public extension UI.View {

    final class Scroll : IUIView, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) unowned var layout: IUILayout?
        public unowned var item: UI.Layout.Item?
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
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var width: UI.Size.Dynamic = .static(.fill) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .static(.fill) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var direction: Direction = [ .vertical, .bounds ] {
            didSet(oldValue) {
                guard self.direction != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(direction: self.direction)
            }
        }
        public var indicatorDirection: Direction = .vertical {
            didSet(oldValue) {
                guard self.indicatorDirection != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(indicatorDirection: self.indicatorDirection)
            }
        }
        public var visibleInset: InsetFloat = .zero {
            didSet(oldValue) {
                guard self.visibleInset != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(visibleInset: self.visibleInset)
            }
        }
        public var contentInset: InsetFloat = .zero {
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
        public private(set) var contentSize: SizeFloat = .zero
        public var contentLayout: IUILayout {
            willSet {
                self.contentLayout.view = nil
            }
            didSet(oldValue) {
                self.contentLayout.view = self
                guard self.isLoaded == true else { return }
                self._view.update(contentLayout: self.contentLayout)
            }
        }
        public private(set) var isScrolling: Bool = false
        public private(set) var isDecelerating: Bool = false
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
        public var color: Color? = nil {
            didSet(oldValue) {
                guard self.color != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet(oldValue) {
                guard self.cornerRadius != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
                self._view.updateShadowPath()
            }
        }
        public var border: UI.Border = .none {
            didSet(oldValue) {
                guard self.border != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet(oldValue) {
                guard self.shadow != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
                self._view.updateShadowPath()
            }
        }
        public var alpha: Float = 1 {
            didSet(oldValue) {
                guard self.alpha != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(alpha: self.alpha)
            }
        }
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _contentOffset: PointFloat = .zero
        private var _refreshColor: Color?
        private var _isRefreshing: Bool = false
        private var _observer: Observer< IUIScrollViewObserver >
        private var _onAppear: ((UI.View.Scroll) -> Void)?
        private var _onDisappear: ((UI.View.Scroll) -> Void)?
        private var _onVisible: ((UI.View.Scroll) -> Void)?
        private var _onVisibility: ((UI.View.Scroll) -> Void)?
        private var _onInvisible: ((UI.View.Scroll) -> Void)?
        private var _onTriggeredRefresh: ((UI.View.Scroll) -> Void)?
        private var _onBeginScrolling: ((UI.View.Scroll) -> Void)?
        private var _onScrolling: ((UI.View.Scroll) -> Void)?
        private var _onEndScrolling: ((UI.View.Scroll, Bool) -> Void)?
        private var _onBeginDecelerating: ((UI.View.Scroll) -> Void)?
        private var _onEndDecelerating: ((UI.View.Scroll) -> Void)?
        private var _onScrollToTop: ((UI.View.Scroll) -> Void)?
        
        public init(
            _ contentLayout: IUILayout
        ) {
            self.contentLayout = contentLayout
            self._reuse = UI.Reuse.Item()
            self._observer = Observer()
            self._contentOffset = contentOffset
            self.contentLayout.view = self
            self._reuse.configure(owner: self)
        }
        
        deinit {
            self._reuse.destroy()
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
                sizeWithWidth: { self.contentLayout.size(available: Size(width: $0, height: available.height)) },
                sizeWithHeight: { self.contentLayout.size(available: Size(width: available.width, height: $0)) },
                size: { self.contentLayout.size(available: available) }
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.layout = layout
            self._onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.layout = nil
            self._onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self._onVisible?(self)
        }
        
        public func visibility() {
            self._onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self._onInvisible?(self)
        }
        
        public func add(observer: IUIScrollViewObserver) {
            self._observer.add(observer, priority: 0)
        }
        
        public func remove(observer: IUIScrollViewObserver) {
            self._observer.remove(observer)
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @available(iOS 10.0, *)
        @discardableResult
        public func onTriggeredRefresh(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onTriggeredRefresh = value
            return self
        }
        
        @discardableResult
        public func onBeginScrolling(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onBeginScrolling = value
            return self
        }
        
        @discardableResult
        public func onScrolling(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onScrolling = value
            return self
        }
        
        @discardableResult
        public func onEndScrolling(_ value: ((UI.View.Scroll, Bool) -> Void)?) -> Self {
            self._onEndScrolling = value
            return self
        }
        
        @discardableResult
        public func onBeginDecelerating(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onBeginDecelerating = value
            return self
        }
        
        @discardableResult
        public func onEndDecelerating(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onEndDecelerating = value
            return self
        }
        
        @discardableResult
        public func onScrollToTop(_ value: ((UI.View.Scroll) -> Void)?) -> Self {
            self._onScrollToTop = value
            return self
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
    func contentLayout(_ value: IUILayout) -> Self {
        self.contentLayout = value
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
    
    @available(iOS 10.0, *)
    @inlinable
    @discardableResult
    func refreshColor(_ value: Color?) -> Self {
        self.refreshColor = value
        return self
    }
    
#endif
    
}

public extension UI.View.Scroll {
    
    func contentOffset(
        with view: IUIView,
        horizontal: ScrollAlignment,
        vertical: ScrollAlignment
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
    
#if os(iOS)
    
    @available(iOS 10.0, *)
    @discardableResult
    func beginRefresh() -> Self {
        self.isRefreshing = true
        return self
    }
    
    @available(iOS 10.0, *)
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

private extension UI.View.Scroll {

    func _scrollToTop() {
        self._onScrollToTop?(self)
        self._observer.notify({ $0.scrollToTop(scrollView: self) })
    }

}

extension UI.View.Scroll : KKScrollViewDelegate {
    
    
    func update(_ view: KKScrollView, contentSize: SizeFloat) {
        self.contentSize = contentSize
    }
    
    func triggeredRefresh(_ view: KKScrollView) {
        self._onTriggeredRefresh?(self)
    }
    
    func beginScrolling(_ view: KKScrollView) {
        if self.isScrolling == false {
            self.isScrolling = true
            self._onBeginScrolling?(self)
            self._observer.notify({ $0.beginScrolling(scrollView: self) })
        }
    }
    
    func scrolling(_ view: KKScrollView, contentOffset: PointFloat) {
        if self._contentOffset != contentOffset {
            self._contentOffset = contentOffset
            self._onScrolling?(self)
            self._observer.notify({ $0.scrolling(scrollView: self) })
        }
    }
    
    func endScrolling(_ view: KKScrollView, decelerate: Bool) {
        if self.isScrolling == true {
            self.isScrolling = false
            self._onEndScrolling?(self, decelerate)
            self._observer.notify({ $0.endScrolling(scrollView: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self._onBeginDecelerating?(self)
            self._observer.notify({ $0.beginDecelerating(scrollView: self) })
        }
    }
    
    func endDecelerating(_ view: KKScrollView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self._onEndDecelerating?(self)
            self._observer.notify({ $0.endDecelerating(scrollView: self) })
        }
    }
    
    func scrollToTop(_ view: KKScrollView) {
        self._scrollToTop()
    }
    
    func isDynamicSize(_ view: KKScrollView) -> Bool {
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
