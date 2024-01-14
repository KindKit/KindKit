//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

protocol KKMaskViewDelegate : AnyObject {
    
    func isDynamic(_ view: KKMaskView) -> Bool
    
}

public final class MaskView {
    
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
    public var content: IView? {
        didSet {
            guard self.content !== oldValue else { return }
            self.layout.content = self.content
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
    public var border: Border = .none {
        didSet {
            guard self.border != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(border: self.border)
            }
        }
    }
    public var cornerRadius: CornerRadius = .none {
        didSet {
            guard self.cornerRadius != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(cornerRadius: self.cornerRadius)
            }
        }
    }
    public var shadow: Shadow? {
        didSet {
            guard self.shadow != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(shadow: self.shadow)
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
    
    lazy var layout = MaskView.Layout()
    
    private lazy var _reuse: Reuse.Item< Reusable > = .init(owner: self)
    @inline(__always) private var _view: Reusable.Content { self._reuse.content }
    
    public init() {
        self.layout.appearedView = self
    }
    
    deinit {
        self._reuse.destroy()
    }

}

public extension MaskView {
    
    @inlinable
    @discardableResult
    func content(_ value: IView?) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IView?) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IView?) -> Self {
        return self.content(value(self))
    }
    
}

extension MaskView : IView {
    
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

extension MaskView : IViewReusable {
    
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

extension MaskView : IViewTransformable {
}

#endif

extension MaskView : IViewDynamicSizeable {
}

extension MaskView : IViewBorderable {
}

extension MaskView : IViewCornerRadiusable {
}

extension MaskView : IViewShadowable {
}

extension MaskView : IViewColorable {
}

extension MaskView : IViewAlphable {
}

extension MaskView : KKMaskViewDelegate {
    
    func isDynamic(_ view: KKMaskView) -> Bool {
        return self.width.isStatic == false || self.height.isStatic == false
    }
    
}
