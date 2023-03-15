//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IUIPagingViewObserver : AnyObject {
    
    func beginDragging(paging: UI.View.Paging)
    func dragging(paging: UI.View.Paging)
    func endDragging(paging: UI.View.Paging, decelerate: Bool)
    func beginDecelerating(paging: UI.View.Paging)
    func endDecelerating(paging: UI.View.Paging)
    
}

protocol KKPagingViewDelegate : AnyObject {
    
    func update(_ view: KKPagingView, numberOfPages: UInt, contentSize: Size)

    func beginDragging(_ view: KKPagingView)
    func dragging(_ view: KKPagingView, currentPage: Double)
    func endDragging(_ view: KKPagingView, decelerate: Bool)
    func beginDecelerating(_ view: KKPagingView)
    func endDecelerating(_ view: KKPagingView)
    
    func isDynamicSize(_ view: KKPagingView) -> Bool
    
}

public extension UI.View {

    final class Paging {
        
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
        public var direction: Direction = .horizontal(bounds: true) {
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
            }
        }
        public var visibleInset: Inset = .zero {
            didSet {
                guard self.visibleInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(visibleInset: self.visibleInset)
                }
            }
        }
        public var currentPage: Double {
            set {
                guard self._currentPage != newValue else { return }
                self._currentPage = newValue
                self.linkedPageable?.currentPage = newValue
                if self.isLoaded == true {
                    self._view.update(
                        direction: self.direction,
                        currentPage: newValue,
                        numberOfPages: self.numberOfPages
                    )
                }
            }
            get { self._currentPage }
        }
        public var numberOfPages: UInt = 0 {
            didSet {
                guard self.numberOfPages != oldValue else { return }
                self.linkedPageable?.numberOfPages = self.numberOfPages
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
        public private(set) var isDragging: Bool = false
        public private(set) var isDecelerating: Bool = false
        public private(set) var isVisible: Bool = false
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
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _isLocked: Bool = false
        private var _currentPage: Double = 0
        private var _observer: Observer< IUIPagingViewObserver > = .init()
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init() {
        }
        
        deinit {
            self._destroy()
        }
        
        public func add(observer: IUIPagingViewObserver) {
            self._observer.add(observer, priority: 0)
        }
        
        public func remove(observer: IUIPagingViewObserver) {
            self._observer.remove(observer)
        }
        
    }
    
}

private extension UI.View.Paging {
    
    func _destroy() {
        self._reuse.destroy()
        self._animation = nil
    }
    
}

public extension UI.View.Paging {
    
    func scrollTo(
        page: UInt,
        duration: TimeInterval? = 0.2,
        completion: (() -> Void)? = nil
    ) {
        let newPage = Double(page)
        let oldPage = self.currentPage
        if newPage != oldPage {
            if let duration = duration {
                self._animation = Animation.default.run(
                    .custom(
                        duration: duration,
                        ease: Animation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self.currentPage = oldPage.lerp(newPage, progress: progress)
                        },
                        completion: {
                            self._animation = nil
                            completion?()
                        }
                    )
                )
            } else {
                self.currentPage = newPage
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    @inlinable
    func animate(currentPage: Double, completion: (() -> Void)?) {
        self.scrollTo(page: UInt(currentPage), duration: 0.2, completion: completion)
    }
    
}

public extension UI.View.Paging {

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
    func content(_ value: IUILayout?) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IUILayout?) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IUILayout?) -> Self {
        return self.content(value(self))
    }
    
}

extension UI.View.Paging : IUIView {
    
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
                return content.size(available: $0)
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

extension UI.View.Paging : IUIViewReusable {
    
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

extension UI.View.Paging : IUIViewTransformable {
}

#endif

extension UI.View.Paging : IUIViewDynamicSizeable {
}

extension UI.View.Paging : IUIViewPageable {
}

extension UI.View.Paging : IUIViewScrollable {
}

extension UI.View.Paging : IUIViewColorable {
}

extension UI.View.Paging : IUIViewAlphable {
}

extension UI.View.Paging : IUIViewLockable {
}

extension UI.View.Paging : KKPagingViewDelegate {
    
    func update(_ view: KKPagingView, numberOfPages: UInt, contentSize: Size) {
        self.numberOfPages = numberOfPages
        self.contentSize = contentSize
    }
    
    func beginDragging(_ view: KKPagingView) {
        if self.isDragging == false {
            self.isDragging = true
            self.onBeginDragging.emit()
            self._observer.notify({ $0.beginDragging(paging: self) })
        }
    }
    
    func dragging(_ view: KKPagingView, currentPage: Double) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.linkedPageable?.currentPage = currentPage
            self.onDragging.emit()
            self._observer.notify({ $0.dragging(paging: self) })
        }
    }
    
    func endDragging(_ view: KKPagingView, decelerate: Bool) {
        if self.isDragging == true {
            self.isDragging = false
            self.onEndDragging.emit(decelerate)
            self._observer.notify({ $0.endDragging(paging: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKPagingView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self.onBeginDecelerating.emit()
            self._observer.notify({ $0.beginDecelerating(paging: self) })
        }
    }
    
    func endDecelerating(_ view: KKPagingView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self.onEndDecelerating.emit()
            self._observer.notify({ $0.endDecelerating(paging: self) })
        }
    }
    
    func isDynamicSize(_ view: KKPagingView) -> Bool {
        return self.width.isStatic == true && self.height.isStatic == true
    }
    
}

public extension IUIView where Self == UI.View.Paging {
    
    @inlinable
    static func paging(_ direction: UI.View.Paging.Direction) -> Self {
        return .init().direction(direction)
    }
    
}

#endif
