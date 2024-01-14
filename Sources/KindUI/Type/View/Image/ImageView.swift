//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

public final class ImageView {
    
    public private(set) weak var appearedLayout: ILayout?
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
    public var size: DynamicSize = .init(.fit, .fit) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var image: Image? {
        didSet {
            guard self.image != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(image: self.image)
            }
            self.setNeedLayout()
        }
    }
    public var mode: Mode = .aspectFit {
        didSet {
            guard self.mode != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(mode: self.mode)
            }
            self.setNeedLayout()
        }
    }
    public var tintColor: Color? {
        didSet {
            guard self.tintColor != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(tintColor: self.tintColor)
            }
        }
    }
    public var color: Color? {
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
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }

}

public extension ImageView {
    
    @inlinable
    @discardableResult
    func image(_ value: Image?) -> Self {
        self.image = value
        return self
    }
    
    @inlinable
    @discardableResult
    func image(_ value: () -> Image?) -> Self {
        return self.image(value())
    }

    @inlinable
    @discardableResult
    func image(_ value: (Self) -> Image?) -> Self {
        return self.image(value(self))
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

extension ImageView : IView {
    
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
        guard let image = self.image else { return .zero }
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

extension ImageView : IViewReusable {
    
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

extension ImageView : IViewTransformable {
}

#endif

extension ImageView : IViewDynamicSizeable {
}

extension ImageView : IViewColorable {
}

extension ImageView : IViewTintColorable {
}

extension ImageView : IViewAlphable {
}
