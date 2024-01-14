//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

public final class RateView {
    
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
    public var itemSize: Size = .init(width: 40, height: 40) {
        didSet {
            guard self.itemSize != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(itemSize: self.itemSize)
            }
            self.setNeedLayout()
        }
    }
    public var itemSpacing: Double = 2 {
        didSet {
            guard self.itemSpacing != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(itemSpacing: self.itemSpacing)
            }
            self.setNeedLayout()
        }
    }
    public var numberOfItem: UInt = 0 {
        didSet {
            guard self.numberOfItem != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(numberOfItem: self.numberOfItem)
            }
            self.setNeedLayout()
        }
    }
    public var rounding: Rounding = .down {
        didSet {
            guard self.rounding != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(rounding: self.rounding)
            }
        }
    }
    public var states: [State] {
        set {
            let value = Self._sort(states: newValue)
            guard self.states != value else { return }
            self._states = value
            if self.isLoaded == true {
                self._view.update(states: self._states)
            }
        }
        get { self._states }
    }
    public var rating: Double = 0 {
        didSet {
            guard self.rating != oldValue else { return }
            if self.isLoaded == true {
                self._view.update(rating: self.rating)
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
    private var _states: [State] = []
    
    public init() {
    }
    
    deinit {
        self._reuse.destroy()
    }
    
}

private extension RateView {
    
    static func _sort(states: [State]) -> [State] {
        return states.sorted(by: { $0.rate < $1.rate })
    }
    
}

public extension RateView {
    
    @inlinable
    @discardableResult
    func itemSize(_ value: Size) -> Self {
        self.itemSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemSize(_ value: () -> Size) -> Self {
        return self.itemSize(value())
    }

    @inlinable
    @discardableResult
    func itemSize(_ value: (Self) -> Size) -> Self {
        return self.itemSize(value(self))
    }
    
    @inlinable
    @discardableResult
    func itemSpacing(_ value: Double) -> Self {
        self.itemSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemSpacing(_ value: () -> Double) -> Self {
        return self.itemSpacing(value())
    }

    @inlinable
    @discardableResult
    func itemSpacing(_ value: (Self) -> Double) -> Self {
        return self.itemSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfItem(_ value: UInt) -> Self {
        self.numberOfItem = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfItem(_ value: () -> UInt) -> Self {
        return self.numberOfItem(value())
    }

    @inlinable
    @discardableResult
    func numberOfItem(_ value: (Self) -> UInt) -> Self {
        return self.numberOfItem(value(self))
    }
    
    @inlinable
    @discardableResult
    func rounding(_ value: Rounding) -> Self {
        self.rounding = value
        return self
    }
    
    @inlinable
    @discardableResult
    func rounding(_ value: () -> Rounding) -> Self {
        return self.rounding(value())
    }

    @inlinable
    @discardableResult
    func rounding(_ value: (Self) -> Rounding) -> Self {
        return self.rounding(value(self))
    }
    
    @inlinable
    @discardableResult
    func states(_ value: [State]) -> Self {
        self.states = value
        return self
    }
    
    @inlinable
    @discardableResult
    func states(_ value: () -> [State]) -> Self {
        return self.states(value())
    }

    @inlinable
    @discardableResult
    func states(_ value: (Self) -> [State]) -> Self {
        return self.states(value(self))
    }
    
    @inlinable
    @discardableResult
    func rating(_ value: Double) -> Self {
        self.rating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func rating(_ value: () -> Double) -> Self {
        return self.rating(value())
    }

    @inlinable
    @discardableResult
    func rating(_ value: (Self) -> Double) -> Self {
        return self.rating(value(self))
    }
    
}

extension RateView : IView {
    
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
        if self.numberOfItem > 1 {
            return Size(
                width: (self.itemSize.width * Double(self.numberOfItem)) + (self.itemSpacing * Double(self.numberOfItem - 1)),
                height: self.itemSize.height
            )
        } else if self.numberOfItem > 0 {
            return self.itemSize
        }
        return .zero
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

extension RateView : IViewReusable {
    
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

extension RateView : IViewTransformable {
}

#endif

extension RateView : IViewColorable {
}

extension RateView : IViewAlphable {
}

#endif
