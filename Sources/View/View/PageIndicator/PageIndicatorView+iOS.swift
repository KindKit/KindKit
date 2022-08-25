//
//  KindKitView
//

#if os(iOS)

import Foundation
import KindKitCore
import KindKitMath

protocol PageIndicatorViewDelegate : AnyObject {
    
    func changed(currentPage: Float)
    
}

public final class PageIndicatorView : IPageIndicatorView {
    
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
    public var width: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var pageColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(pageColor: self.pageColor)
        }
    }
    public var currentPageColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(currentPageColor: self.currentPageColor)
        }
    }
    public var currentPage: Float {
        set(value) {
            if self._currentPage != value {
                self._currentPage = value
                self.pagingView?.currentPage = value
                if self.isLoaded == true {
                    self._view.update(currentPage: self.currentPage)
                }
            }
        }
        get { return self._currentPage }
    }
    public var numberOfPages: UInt {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(numberOfPages: self.numberOfPages)
        }
    }
    public unowned var pagingView: IPagingView? {
        willSet(newValue) {
            guard self.pagingView !== newValue else { return }
            self.pagingView?.remove(pageIndicator: self)
        }
        didSet(oldValue) {
            guard self.pagingView !== oldValue else { return }
            self.pagingView?.add(pageIndicator: self)
        }
    }
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
        }
    }
    public var alpha: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _currentPage: Float
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    
    public init(
        width: StaticSizeBehaviour = .fill,
        height: StaticSizeBehaviour,
        pageColor: Color,
        currentPageColor: Color,
        currentPage: Float = 0,
        numberOfPages: UInt = 0,
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
        self.pageColor = pageColor
        self.currentPageColor = currentPageColor
        self._currentPage = currentPage
        self.numberOfPages = numberOfPages
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
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
        return StaticSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height
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
    
}

extension PageIndicatorView : PageIndicatorViewDelegate {
    
    func changed(currentPage: Float) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.pagingView?.scrollTo(page: UInt(currentPage))
        }
    }
    
}

#endif
