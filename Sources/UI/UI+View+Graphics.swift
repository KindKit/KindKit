//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {

    final class Graphics : IUIView, IUIViewReusable, IUIViewStaticSizeable, IUIViewLockable, IUIViewColorable, IUIViewAlphable {
        
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
        public var width: UI.Size.Static = .fill {
            didSet {
                guard self.width != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fill {
            didSet {
                guard self.height != oldValue else { return }
                self.setNeedForceLayout()
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
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
            }
        }
        public var canvas: IGraphicsCanvas {
            willSet(oldValue) {
                guard self.canvas !== oldValue else { return }
                self.canvas.detach()
            }
            didSet {
                guard self.canvas !== oldValue else { return }
                self.canvas.attach(view: self)
                if self.isLoaded == true {
                    self._view.update(canvas: self.canvas)
                }
            }
        }
        public var onAppear: ((UI.View.Graphics) -> Void)?
        public var onDisappear: ((UI.View.Graphics) -> Void)?
        public var onVisible: ((UI.View.Graphics) -> Void)?
        public var onVisibility: ((UI.View.Graphics) -> Void)?
        public var onInvisible: ((UI.View.Graphics) -> Void)?
        public var onChangeStyle: ((UI.View.Graphics, Bool) -> Void)?
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { return self._reuse.content }
        private var _isLocked: Bool = false
        
        public init(
            _ canvas: IGraphicsCanvas
        ) {
            self.canvas = canvas
            self.canvas.attach(view: self)
        }
        
        public convenience init(
            canvas: IGraphicsCanvas,
            configure: (UI.View.Graphics) -> Void
        ) {
            self.init(canvas)
            self.modify(configure)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Static.apply(
                available: available,
                width: self.width,
                height: self.height
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
        
        public func setNeedRedraw() {
            guard self.isAppeared == true else { return }
            self._view.setNeedsDisplay()
        }
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self.onChangeStyle?(self, userInteraction)
        }
        
    }
    
}

public extension UI.View.Graphics {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ value: ((UI.View.Graphics, Bool) -> Void)?) -> Self {
        self.onChangeStyle = value
        return self
    }
    
}

#endif
