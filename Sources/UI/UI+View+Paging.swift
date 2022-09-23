//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IUIPagingViewObserver : AnyObject {
    
    func beginPaginging(pagingView: UI.View.Paging)
    func paginging(pagingView: UI.View.Paging)
    func endPaginging(pagingView: UI.View.Paging, decelerate: Bool)
    func beginDecelerating(pagingView: UI.View.Paging)
    func endDecelerating(pagingView: UI.View.Paging)
    
}

protocol KKPagingViewDelegate : AnyObject {
    
    func update(_ view: KKPagingView, numberOfPages: UInt, contentSize: SizeFloat)

    func beginPaginging(_ view: KKPagingView)
    func paginging(_ view: KKPagingView, currentPage: Float)
    func endPaginging(_ view: KKPagingView, decelerate: Bool)
    func beginDecelerating(_ view: KKPagingView)
    func endDecelerating(_ view: KKPagingView)
    
    func isDynamicSize(_ view: KKPagingView) -> Bool
    
}

public extension UI.View {

    final class Paging : IUIView, IUIViewPageable, IUIViewDynamicSizeable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var width: UI.Size.Dynamic = .fill {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var direction: Direction = .horizontal(bounds: true) {
            didSet(oldValue) {
                guard self.direction != oldValue else { return }
                guard self.isLoaded == true else { return }
                self._view.update(direction: self.direction)
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
        public var currentPage: Float {
            set(value) {
                if self._currentPage != value {
                    self._currentPage = value
                    self.linkedPageable?.currentPage = value
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
        public var numberOfPages: UInt = 0 {
            didSet(oldValue) {
                guard self.numberOfPages != oldValue else { return }
                self.linkedPageable?.numberOfPages = self.numberOfPages
            }
        }
        public unowned var linkedPageable: IUIViewPageable? {
            willSet(newValue) {
                guard self.linkedPageable !== newValue else { return }
                self.linkedPageable?.linkedPageable = nil
            }
            didSet(oldValue) {
                guard self.linkedPageable !== oldValue else { return }
                self.linkedPageable?.linkedPageable = self
            }
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
        public private(set) var isPaging: Bool = false
        public private(set) var isDecelerating: Bool = false
        public var color: UI.Color? = nil {
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
        private var _currentPage: Float = 0
        private var _observer: Observer< IUIPagingViewObserver >
        private var _onAppear: ((UI.View.Paging) -> Void)?
        private var _onDisappear: ((UI.View.Paging) -> Void)?
        private var _onVisible: ((UI.View.Paging) -> Void)?
        private var _onVisibility: ((UI.View.Paging) -> Void)?
        private var _onInvisible: ((UI.View.Paging) -> Void)?
        private var _onBeginPaginging: ((UI.View.Paging) -> Void)?
        private var _onPaginging: ((UI.View.Paging) -> Void)?
        private var _onEndPaginging: ((UI.View.Paging, Bool) -> Void)?
        private var _onBeginDecelerating: ((UI.View.Paging) -> Void)?
        private var _onEndDecelerating: ((UI.View.Paging) -> Void)?
        
        public init(
            _ contentLayout: IUILayout
        ) {
            self.contentLayout = contentLayout
            self._reuse = UI.Reuse.Item()
            self._observer = Observer()
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
        
        public func add(observer: IUIPagingViewObserver) {
            self._observer.add(observer, priority: 0)
        }
        
        public func remove(observer: IUIPagingViewObserver) {
            self._observer.remove(observer)
        }
        
        @discardableResult
        public func currentPage(
            _ value: Float,
            animated: Bool,
            completion: (() -> Void)?
        ) -> Self {
            self.scrollTo(
                page: UInt(value),
                duration: animated == true ? 0.2 : nil,
                completion: completion
            )
            return self
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onBeginPaginging(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onBeginPaginging = value
            return self
        }
        
        @discardableResult
        public func onPaginging(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onPaginging = value
            return self
        }
        
        @discardableResult
        public func onEndPaginging(_ value: ((UI.View.Paging, Bool) -> Void)?) -> Self {
            self._onEndPaginging = value
            return self
        }
        
        @discardableResult
        public func onBeginDecelerating(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onBeginDecelerating = value
            return self
        }
        
        @discardableResult
        public func onEndDecelerating(_ value: ((UI.View.Paging) -> Void)?) -> Self {
            self._onEndDecelerating = value
            return self
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
    func contentLayout(_ value: IUILayout) -> Self {
        self.contentLayout = value
        return self
    }
    
    func scrollTo(
        page: UInt,
        duration: TimeInterval? = 0.2,
        completion: (() -> Void)? = nil
    ) {
        let newPage = Float(page)
        let oldPage = self.currentPage
        if newPage != oldPage {
            if let duration = duration {
                Animation.default.run(
                    duration: duration,
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [weak self] progress in
                        self?.currentPage = oldPage.lerp(newPage, progress: progress)
                    },
                    completion: { completion?() }
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

extension UI.View.Paging : KKPagingViewDelegate {
    
    func update(_ view: KKPagingView, numberOfPages: UInt, contentSize: SizeFloat) {
        self.numberOfPages = numberOfPages
        self.contentSize = contentSize
    }
    
    func beginPaginging(_ view: KKPagingView) {
        if self.isPaging == false {
            self.isPaging = true
            self._onBeginPaginging?(self)
            self._observer.notify({ $0.beginPaginging(pagingView: self) })
        }
    }
    
    func paginging(_ view: KKPagingView, currentPage: Float) {
        if self._currentPage != currentPage {
            self._currentPage = currentPage
            self.linkedPageable?.currentPage = currentPage
            self._onPaginging?(self)
            self._observer.notify({ $0.paginging(pagingView: self) })
        }
    }
    
    func endPaginging(_ view: KKPagingView, decelerate: Bool) {
        if self.isPaging == true {
            self.isPaging = false
            self._onEndPaginging?(self, decelerate)
            self._observer.notify({ $0.endPaginging(pagingView: self, decelerate: decelerate) })
        }
    }
    
    func beginDecelerating(_ view: KKPagingView) {
        if self.isDecelerating == false {
            self.isDecelerating = true
            self._onBeginDecelerating?(self)
            self._observer.notify({ $0.beginDecelerating(pagingView: self) })
        }
    }
    
    func endDecelerating(_ view: KKPagingView) {
        if self.isDecelerating == true {
            self.isDecelerating = false
            self._onEndDecelerating?(self)
            self._observer.notify({ $0.endDecelerating(pagingView: self) })
        }
    }
    
    func isDynamicSize(_ view: KKPagingView) -> Bool {
        return self.width.isStatic == true && self.height.isStatic == true
    }
    
}

#endif
