//
//  KindKitView
//

#if os(iOS)

import Foundation
import KindKitCore
import KindKitMath
import KindKitObserver

protocol PagingViewDelegate : AnyObject {
    
    func _update(numberOfPages: UInt, contentSize: SizeFloat)

    func _beginPaginging()
    func _paginging(currentPage: Float)
    func _endPaginging(decelerate: Bool)
    func _beginDecelerating()
    func _endDecelerating()
    
    func _isDynamicSize() -> Bool
    
}

public final class PagingView< Layout : ILayout > : IPagingView {
    
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
    public var direction: PagingViewDirection {
        didSet(oldValue) {
            guard self.direction != oldValue else { return }
            guard self.isLoaded == true else { return }
            self._view.update(direction: self.direction)
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
    public var currentPage: Float {
        set(value) {
            if self._currentPage != value {
                self._currentPage = value
                for pageIndicator in self._pageIndicators {
                    pageIndicator.currentPage = value
                }
                if self.isLoaded == true {
                    self._view.update(
                        direction: self.direction,
                        currentPage: value,
                        numberOfPages: self.numberOfPages
                    )
                }
            }
        }
        get { return self._currentPage }
    }
    public private(set) var numberOfPages: UInt {
        didSet(oldValue) {
            guard self.numberOfPages != oldValue else { return }
            for pageIndicator in self._pageIndicators {
                pageIndicator.numberOfPages = self.numberOfPages
            }
        }
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
    public private(set) var isPaging: Bool
    public private(set) var isDecelerating: Bool
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
    private var _currentPage: Float
    private var _observer: Observer< IPagingViewObserver >
    private var _pageIndicators: [IPageIndicatorView]
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onBeginPaginging: (() -> Void)?
    private var _onPaginging: (() -> Void)?
    private var _onEndPaginging: ((_ decelerate: Bool) -> Void)?
    private var _onBeginDecelerating: (() -> Void)?
    private var _onEndDecelerating: (() -> Void)?
    
    public init(
        width: DynamicSizeBehaviour = .static(.fill),
        height: DynamicSizeBehaviour = .fit,
        direction: PagingViewDirection = .horizontal(bounds: true),
        visibleInset: InsetFloat = .zero,
        contentInset: InsetFloat = .zero,
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
        self.visibleInset = visibleInset
        self.contentInset = contentInset
        self.contentLayout = contentLayout
        self.numberOfPages = 0
        self.contentSize = .zero
        self.isPaging = false
        self.isDecelerating = false
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
        self._observer = Observer()
        self._pageIndicators = []
        self._currentPage = 0
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
    
    public func add(observer: IPagingViewObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    public func remove(observer: IPagingViewObserver) {
        self._observer.remove(observer)
    }
    
    public func add(pageIndicator: IPageIndicatorView) {
        if self._pageIndicators.contains(where: { $0 === pageIndicator }) == false {
            self._pageIndicators.append(pageIndicator)
            pageIndicator.pagingView = self
        }
    }
    
    public func remove(pageIndicator: IPageIndicatorView) {
        if let index = self._pageIndicators.firstIndex(where: { $0 === pageIndicator }) {
            self._pageIndicators.remove(at: index)
            pageIndicator.pagingView = nil
        }
    }
    
    @discardableResult
    public func contentLayout(_ value: Layout) -> Self {
        self.contentLayout = value
        return self
    }
    
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
    
    @discardableResult
    public func onBeginPaginging(_ value: (() -> Void)?) -> Self {
        self._onBeginPaginging = value
        return self
    }
    
    @discardableResult
    public func onPaginging(_ value: (() -> Void)?) -> Self {
        self._onPaginging = value
        return self
    }
    
    @discardableResult
    public func onEndPaginging(_ value: ((_ decelerate: Bool) -> Void)?) -> Self {
        self._onEndPaginging = value
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
    
}

extension PagingView : PagingViewDelegate {
    
    func _update(numberOfPages: UInt, contentSize: SizeFloat) {
        self.numberOfPages = numberOfPages
        self.contentSize = contentSize
    }
    
    func _beginPaginging() {
        if self.isPaging == false {
            self.isPaging = true
            self._onBeginPaginging?()
            self._observer.notify({ $0.beginPaginging(pagingView: self) })
        }
    }
    
    func _paginging(currentPage: Float) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            for pageIndicator in self._pageIndicators {
                pageIndicator.currentPage = currentPage
            }
            self._onPaginging?()
            self._observer.notify({ $0.paginging(pagingView: self) })
        }
    }
    
    func _endPaginging(decelerate: Bool) {
        if self.isPaging == true {
            self.isPaging = false
            self._onEndPaginging?(decelerate)
            self._observer.notify({ $0.endPaginging(pagingView: self, decelerate: decelerate) })
        }
    }
    
    func _beginDecelerating() {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self._onBeginDecelerating?()
            self._observer.notify({ $0.beginDecelerating(pagingView: self) })
        }
    }
    
    func _endDecelerating() {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self._onEndDecelerating?()
            self._observer.notify({ $0.endDecelerating(pagingView: self) })
        }
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

#endif
