//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

public final class AnimatedImageView {
    
    public private(set) weak var appearedLayout: ILayout?
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(frame: self.frame)
            }
        }
    }
#if os(iOS)
    public var transform: Transform = .init() {
        didSet {
            guard self.transform != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(transform: self.transform)
            }
        }
    }
#endif
    public var size: DynamicSize = .init(.fit, .fit) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var images: [Image] = [] {
        didSet {
            guard self.images != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(images: self.images)
            }
            self.setNeedLayout()
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
            self.setNeedLayout()
        }
    }
    public var tintColor: Color? {
        didSet {
            guard self.tintColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.kk_update(tintColor: self.tintColor)
            }
        }
    }
    public var color: Color? {
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
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

public extension AnimatedImageView {
    
    @inlinable
    @discardableResult
    func images(_ value: [Image]) -> Self {
        self.images = value
        return self
    }
    
    @inlinable
    @discardableResult
    func images(_ value: () -> [Image]) -> Self {
        return self.images(value())
    }

    @inlinable
    @discardableResult
    func images(_ value: (Self) -> [Image]) -> Self {
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

extension AnimatedImageView : IView {
    
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
    
    public func appear(to layout: ILayout) {
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

extension AnimatedImageView : IViewReusable {
    
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

extension AnimatedImageView : IViewTransformable {
}

#endif

extension AnimatedImageView : IViewDynamicSizeable {
}

extension AnimatedImageView : IViewAnimatable {
}

extension AnimatedImageView : IViewColorable {
}

extension AnimatedImageView : IViewTintColorable {
}

extension AnimatedImageView :  IViewAlphable {
}
