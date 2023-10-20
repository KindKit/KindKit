//
//  KindKit
//

import Foundation

public extension UI.View {
    
    final class AnimatedImage {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Dynamic = .init(.fit, .fit) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var images: [UI.Image] = [] {
            didSet {
                guard self.images != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(images: self.images)
                }
                self.setNeedForceLayout()
            }
        }
        public var duration: TimeInterval = 1 {
            didSet {
                guard self.duration != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(duration: self.duration)
                }
            }
        }
        public var `repeat`: Repeat = .infinity {
            didSet {
                guard self.repeat != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(repeat: self.repeat)
                }
            }
        }
        public var mode: Mode = .aspectFit {
            didSet {
                guard self.mode != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(mode: self.mode)
                }
                self.setNeedForceLayout()
            }
        }
        public var tintColor: UI.Color? {
            didSet {
                guard self.tintColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(tintColor: self.tintColor)
                }
            }
        }
        public var color: UI.Color? {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var alpha: Double = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
            }
        }
        public var isAnimating: Bool {
            set {
                if newValue == true {
                    self._view.kk_start()
                } else if self.isLoaded == true {
                    self._view.kk_stop()
                }
            }
            get {
                guard self.isLoaded == true else { return false }
                return self._view.kkIsAnimating
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
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.AnimatedImage {
    
    @inlinable
    @discardableResult
    func images(_ value: [UI.Image]) -> Self {
        self.images = value
        return self
    }
    
    @inlinable
    @discardableResult
    func images(_ value: () -> [UI.Image]) -> Self {
        return self.images(value())
    }

    @inlinable
    @discardableResult
    func images(_ value: (Self) -> [UI.Image]) -> Self {
        return self.images(value(self))
    }
    
    @inlinable
    @discardableResult
    func duration(_ value: TimeInterval) -> Self {
        self.duration = value
        return self
    }
    
    @inlinable
    @discardableResult
    func duration(_ value: () -> TimeInterval) -> Self {
        return self.duration(value())
    }

    @inlinable
    @discardableResult
    func duration(_ value: (Self) -> TimeInterval) -> Self {
        return self.duration(value(self))
    }
    
    @inlinable
    @discardableResult
    func `repeat`(_ value: Repeat) -> Self {
        self.repeat = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `repeat`(_ value: (Self) -> Repeat) -> Self {
        return self.repeat(value(self))
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: () -> Mode) -> Self {
        return self.mode(value())
    }

    @inlinable
    @discardableResult
    func mode(_ value: (Self) -> Mode) -> Self {
        return self.mode(value(self))
    }
    
}

extension UI.View.AnimatedImage : IUIView {
    
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
        guard let image = self.images.first else { return .zero }
        switch self.mode {
        case .origin:
            return image.size
        case .aspectFit, .aspectFill:
            return self.size.apply(
                available: available,
                size: { available in
                    if available.width.isInfinite == false {
                        let aspectRatio = image.size.aspectRatio
                        return .init(
                            width: available.width,
                            height: available.width / aspectRatio
                        )
                    } else if available.height.isInfinite == false {
                        let aspectRatio = image.size.aspectRatio
                        return .init(
                            width: available.height * aspectRatio,
                            height: available.height
                        )
                    }
                    return image.size
                }
            )
        }
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

extension UI.View.AnimatedImage : IUIViewReusable {
    
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

extension UI.View.AnimatedImage : IUIViewTransformable {
}

#endif

extension UI.View.AnimatedImage : IUIViewDynamicSizeable {
}

extension UI.View.AnimatedImage : IUIViewAnimatable {
}

extension UI.View.AnimatedImage : IUIViewColorable {
}

extension UI.View.AnimatedImage : IUIViewTintColorable {
}

extension UI.View.AnimatedImage :  IUIViewAlphable {
}

public extension IUIView where Self == UI.View.AnimatedImage {
    
    @inlinable
    static func animatedImage(_ images: [UI.Image]) -> Self {
        return .init().images(images)
    }
    
}
