//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Progress {
        
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
        public var size: UI.Size.Static = .init(.fill, .fixed(21)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var progress: Double = 0 {
            didSet {
                guard self.progress != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(progress: self.progress)
                }
            }
        }
        public var progressColor: UI.Color? {
            didSet {
                guard self.progressColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(progressColor: self.progressColor)
                }
            }
        }
        public var trackColor: UI.Color? {
            didSet {
                guard self.trackColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(trackColor: self.trackColor)
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
                self.setNeedLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Progress {
    
    @inlinable
    @discardableResult
    func progressColor(_ value: UI.Color) -> Self {
        self.progressColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progressColor(_ value: () -> UI.Color) -> Self {
        return self.progressColor(value())
    }

    @inlinable
    @discardableResult
    func progressColor(_ value: (Self) -> UI.Color) -> Self {
        return self.progressColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func trackColor(_ value: UI.Color) -> Self {
        self.trackColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trackColor(_ value: () -> UI.Color) -> Self {
        return self.trackColor(value())
    }

    @inlinable
    @discardableResult
    func trackColor(_ value: (Self) -> UI.Color) -> Self {
        return self.trackColor(value(self))
    }
    
}

extension UI.View.Progress : IUIView {
    
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
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension UI.View.Progress : IUIViewReusable {
    
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

extension UI.View.Progress : IUIViewTransformable {
}

#endif

extension UI.View.Progress : IUIViewStaticSizeable {
}

extension UI.View.Progress : IUIViewProgressable {
}

extension UI.View.Progress : IUIViewColorable {
}

extension UI.View.Progress : IUIViewAlphable {
}

public extension IUIView where Self == UI.View.Progress {
    
    @inlinable
    static func progress() -> Self {
        return .init()
    }
    
}
