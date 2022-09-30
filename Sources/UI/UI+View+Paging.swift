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
    
    func update(_ view: KKPagingView, numberOfPages: UInt, contentSize: SizeFloat)

    func beginDragging(_ view: KKPagingView)
    func dragging(_ view: KKPagingView, currentPage: Float)
    func endDragging(_ view: KKPagingView, decelerate: Bool)
    func beginDecelerating(_ view: KKPagingView)
    func endDecelerating(_ view: KKPagingView)
    
    func isDynamicSize(_ view: KKPagingView) -> Bool
    
}

public extension UI.View {

    final class Paging : IUIView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewPageable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var currentPage: Float {
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
            get { return self._currentPage }
        }
        public var numberOfPages: UInt = 0 {
            didSet {
                guard self.numberOfPages != oldValue else { return }
                self.linkedPageable?.numberOfPages = self.numberOfPages
            }
        }
        public unowned var linkedPageable: IUIViewPageable? {
            willSet {
                guard self.linkedPageable !== newValue else { return }
                self.linkedPageable?.linkedPageable = nil
            }
            didSet {
                guard self.linkedPageable !== oldValue else { return }
                self.linkedPageable?.linkedPageable = self
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
                    self._view.update(color: self.color)
                }
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.cornerRadius != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(cornerRadius: self.cornerRadius)
                }
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.border != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(border: self.border)
                }
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.shadow != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(shadow: self.shadow)
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
        public var direction: Direction = .horizontal(bounds: true) {
            didSet {
                guard self.direction != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(direction: self.direction)
                }
            }
        }
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
        public private(set) var contentSize: SizeFloat = .zero
        public var content: IUILayout {
            didSet {
                guard self.content.view !== oldValue else { return }
                oldValue.view = nil
                self.content.view = self
                if self.isLoaded == true {
                    self._view.update(content: self.content)
                }
            }
        }
        public private(set) var isDragging: Bool = false
        public private(set) var isDecelerating: Bool = false
        public var onAppear: ((UI.View.Paging) -> Void)?
        public var onDisappear: ((UI.View.Paging) -> Void)?
        public var onVisible: ((UI.View.Paging) -> Void)?
        public var onVisibility: ((UI.View.Paging) -> Void)?
        public var onInvisible: ((UI.View.Paging) -> Void)?
        public var onChangeStyle: ((UI.View.Paging, Bool) -> Void)?
        public var onBeginDragging: ((UI.View.Paging) -> Void)?
        public var onDragging: ((UI.View.Paging) -> Void)?
        public var onEndDragging: ((UI.View.Paging, Bool) -> Void)?
        public var onBeginDecelerating: ((UI.View.Paging) -> Void)?
        public var onEndDecelerating: ((UI.View.Paging) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _isLocked: Bool = false
        private var _currentPage: Float = 0
        private var _observer: Observer< IUIPagingViewObserver >
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            _ content: IUILayout
        ) {
            self.content = content
            self._reuse = UI.Reuse.Item()
            self._observer = Observer()
            self.content.view = self
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            content: IUILayout,
            configure: (UI.View.Paging) -> Void
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
        
        public func add(observer: IUIPagingViewObserver) {
            self._observer.add(observer, priority: 0)
        }
        
        public func remove(observer: IUIPagingViewObserver) {
            self._observer.remove(observer)
        }
        
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
    
    @inlinable
    @discardableResult
    func content(_ value: IUILayout) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    func animate(currentPage: Float, completion: (() -> Void)?) {
        self.scrollTo(page: UInt(currentPage), duration: 0.2, completion: completion)
    }
    
}

public extension UI.View.Paging {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((UI.View.Paging, Bool) -> Void)?) -> Self {
        self.onChangeStyle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDragging(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onBeginDragging = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDragging(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onDragging = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDragging(_ value: ((UI.View.Paging, Bool) -> Void)?) -> Self {
        self.onEndDragging = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginDecelerating(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onBeginDecelerating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndDecelerating(_ value: ((UI.View.Paging) -> Void)?) -> Self {
        self.onEndDecelerating = value
        return self
    }
    
}

public extension UI.View.Paging {
    
    func scrollTo(
        page: UInt,
        duration: TimeInterval? = 0.2,
        completion: (() -> Void)? = nil
    ) {
        let newPage = Float(page)
        let oldPage = self.currentPage
        if newPage != oldPage {
            if let duration = duration {
                self._animation = Animation.default.run(
                    duration: duration,
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self.currentPage = oldPage.lerp(newPage, progress: progress)
                    },
                    completion: {
                        self._animation = nil
                        completion?()
                    }
                )
            } else {
                self.currentPage = newPage
                completion?()
            }
        } else {
            completion?()
        }
    }
    
}

private extension UI.View.Paging {
    
    func _destroy() {
        self._reuse.destroy()
        self._animation = nil
    }
    
}

extension UI.View.Paging : KKPagingViewDelegate {
    
    func update(_ view: KKPagingView, numberOfPages: UInt, contentSize: SizeFloat) {
        self.numberOfPages = numberOfPages
        self.contentSize = contentSize
    }
    
    func beginDragging(_ view: KKPagingView) {
        if self.isDragging == false {
            self.isDragging = true
            self.onBeginDragging?(self)
            self._observer.notify({ $0.beginDragging(paging: self) })
        }
    }
    
    func dragging(_ view: KKPagingView, currentPage: Float) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.linkedPageable?.currentPage = currentPage
            self.onDragging?(self)
            self._observer.notify({ $0.dragging(paging: self) })
        }
    }
    
    func endDragging(_ view: KKPagingView, decelerate: Bool) {
        if self.isDragging == true {
            self.isDragging = false
            self.onEndDragging?(self, decelerate)
            self._observer.notify({ $0.endDragging(paging: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKPagingView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self.onBeginDecelerating?(self)
            self._observer.notify({ $0.beginDecelerating(paging: self) })
        }
    }
    
    func endDecelerating(_ view: KKPagingView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self.onEndDecelerating?(self)
            self._observer.notify({ $0.endDecelerating(paging: self) })
        }
    }
    
    func isDynamicSize(_ view: KKPagingView) -> Bool {
        return self.width.isStatic == true && self.height.isStatic == true
    }
    
}

#endif
