//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKPageIndicatorViewDelegate : AnyObject {
    
    func changed(_ view: KKPageIndicatorView, currentPage: Double)
    
}

public extension UI.View {

    final class PageIndicator {
        
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
        public var size: UI.Size.Static = .init(.fill, .fixed(26)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
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
        public weak var linkedPageable: IUIViewPageable? {
            willSet {
                guard self.linkedPageable !== newValue else { return }
                self.linkedPageable?.linkedPageable = nil
            }
            didSet {
                guard self.linkedPageable !== oldValue else { return }
                self.linkedPageable?.linkedPageable = self
            }
        }
        public var pageColor: UI.Color? {
            didSet {
                guard self.pageColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(pageColor: self.pageColor)
                }
            }
        }
        public var currentPageColor: UI.Color? {
            didSet {
                guard self.currentPageColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(currentPageColor: self.currentPageColor)
                }
            }
        }
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
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear: Signal.Empty< Void > = .init()
        public let onDisappear: Signal.Empty< Void > = .init()
        public let onVisible: Signal.Empty< Void > = .init()
        public let onVisibility: Signal.Empty< Void > = .init()
        public let onInvisible: Signal.Empty< Void > = .init()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _currentPage: Double = 0
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.PageIndicator {
    
    @inlinable
    @discardableResult
    func pageColor(_ value: UI.Color?) -> Self {
        self.pageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPageColor(_ value: UI.Color?) -> Self {
        self.currentPageColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func currentPage(_ value: Double) -> Self {
        self.currentPage = value
        return self
    }
    
    @inlinable
    func animate(currentPage: Double, completion: (() -> Void)?) {
        self.currentPage = currentPage
    }
    
}

extension UI.View.PageIndicator : IUIView {
    
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

extension UI.View.PageIndicator : IUIViewReusable {
    
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

extension UI.View.PageIndicator : IUIViewTransformable {
}

#endif

extension UI.View.PageIndicator : IUIViewStaticSizeable {
}

extension UI.View.PageIndicator : IUIViewPageable {
}

extension UI.View.PageIndicator : IUIViewColorable {
}

extension UI.View.PageIndicator : IUIViewAlphable {
}

extension UI.View.PageIndicator : KKPageIndicatorViewDelegate {
    
    func changed(_ view: KKPageIndicatorView, currentPage: Double) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.linkedPageable?.animate(currentPage: currentPage, completion: nil)
        }
    }
    
}

public extension IUIView where Self == UI.View.PageIndicator {
    
    @inlinable
    static func pageIndicator() -> Self {
        return .init()
    }
    
}

#endif
