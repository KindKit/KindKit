//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKPageIndicatorViewDelegate : AnyObject {
    
    func changed(_ view: KKPageIndicatorView, currentPage: Double)
    
}

public final class PageIndicatorView {
    
    public private(set) weak var appearedLayout: Layout?
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
    public var size: StaticSize = .init(.fill, .fixed(26)) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var currentPage: Double {
        set {
            guard self._currentPage != newValue else { return }
            self._currentPage = newValue
            self.linkedPageable?.currentPage = newValue
            if self.isLoaded == true {
                self._view.update(currentPage: self.currentPage)
            }
        }
        get { self._currentPage }
    }
    public var numberOfPages: UInt = 0 {
        didSet {
            guard self.numberOfPages != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(numberOfPages: self.numberOfPages)
            }
        }
    }
    public weak var linkedPageable: IViewSupportPages? {
        willSet {
            guard self.linkedPageable !== newValue else { return }
            self.linkedPageable?.linkedPageable = nil
        }
        didSet {
            guard self.linkedPageable !== oldValue else { return }
            self.linkedPageable?.linkedPageable = self
        }
    }
    public var pageColor: KindGraphics.Color? {
        didSet {
            guard self.pageColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(pageColor: self.pageColor)
            }
        }
    }
    public var currentPageColor: KindGraphics.Color? {
        didSet {
            guard self.currentPageColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(currentPageColor: self.currentPageColor)
            }
        }
    }
    public var color: KindGraphics.Color? {
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
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    private var _currentPage: Double = 0
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension PageIndicatorView {
    
    @inlinable
    func animate(currentPage: Double, completion: (() -> Void)?) {
        self.currentPage = currentPage
    }
    
}

public extension PageIndicatorView {
    
    @inlinable
    @discardableResult
    func pageColor(_ value: Color?) -> Self {
        self.pageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func pageColor(_ value: () -> Color?) -> Self {
        return self.pageColor(value())
    }

    @inlinable
    @discardableResult
    func pageColor(_ value: (Self) -> Color?) -> Self {
        return self.pageColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func currentPageColor(_ value: Color?) -> Self {
        self.currentPageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPageColor(_ value: () -> Color?) -> Self {
        return self.currentPageColor(value())
    }

    @inlinable
    @discardableResult
    func currentPageColor(_ value: (Self) -> Color?) -> Self {
        return self.currentPageColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Double) -> Self {
        self.currentPage = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: () -> Double) -> Self {
        return self.currentPage(value())
    }

    @inlinable
    @discardableResult
    func currentPage(_ value: (Self) -> Double) -> Self {
        return self.currentPage(value(self))
    }
    
}

extension PageIndicatorView : IView {
    
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
        return self.size.apply(available: available)
    }
    
    public func appear(to layout: Layout) {
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

extension PageIndicatorView : IViewReusable {
    
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

extension PageIndicatorView : IViewSupportTransform {
}

#endif

extension PageIndicatorView : IViewSupportStaticSize {
}

extension PageIndicatorView : IViewSupportPages {
}

extension PageIndicatorView : IViewSupportColor {
}

extension PageIndicatorView : IViewSupportAlpha {
}

extension PageIndicatorView : KKPageIndicatorViewDelegate {
    
    func changed(_ view: KKPageIndicatorView, currentPage: Double) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.linkedPageable?.animate(currentPage: currentPage, completion: nil)
        }
    }
    
}

#endif
