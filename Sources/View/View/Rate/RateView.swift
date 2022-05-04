//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class RateView : IRateView {
    
    public private(set) unowned var layout: ILayout?
    public unowned var item: LayoutItem?
    public var native: NativeView {
        return self._view
    }
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    public var bounds: RectFloat {
        guard self.isLoaded == true else { return .zero }
        return RectFloat(self._view.bounds)
    }
    public private(set) var isVisible: Bool
    public var isHidden: Bool {
        didSet(oldValue) {
            guard self.isHidden != oldValue else { return }
            self.setNeedForceLayout()
        }
    }
    public var itemSize: SizeFloat {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(itemSize: self.itemSize)
            self.setNeedForceLayout()
        }
    }
    public var itemSpacing: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(itemSpacing: self.itemSpacing)
            self.setNeedForceLayout()
        }
    }
    public var numberOfItem: UInt {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(numberOfItem: self.numberOfItem)
            self.setNeedForceLayout()
        }
    }
    public var rounding: RateViewRounding {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(rounding: self.rounding)
        }
    }
    public var states: [RateViewState] {
        set(value) {
            guard self.isLoaded == true else { return }
            self._states = Self._sort(states: value)
            self._view.update(states: self._states)
        }
        get { return self._states }
    }
    public var rating: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(rating: self.rating)
        }
    }
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
        }
    }
    public var alpha: Float {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(alpha: self.alpha)
        }
    }
    
    private var _reuse: ReuseItem< Reusable >
    private var _view: Reusable.Content {
        return self._reuse.content()
    }
    private var _states: [RateViewState]
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    
    public init(
        itemSize: SizeFloat,
        itemSpacing: Float,
        numberOfItem: UInt,
        rounding: RateViewRounding = .down,
        states: [RateViewState],
        rating: Float,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
        self.numberOfItem = numberOfItem
        self.rounding = rounding
        self._states = Self._sort(states: states)
        self.rating = rating
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
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
        if self.numberOfItem > 1 {
            return SizeFloat(
                width: (self.itemSize.width * Float(self.numberOfItem)) + (self.itemSpacing * Float(self.numberOfItem - 1)),
                height: self.itemSize.height
            )
        } else if self.numberOfItem > 0 {
            return self.itemSize
        }
        return .zero
    }
    
    public func appear(to layout: ILayout) {
        self.layout = layout
        self._onAppear?()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.layout = nil
        self._onDisappear?()
    }
    
    public func visible() {
        self.isVisible = true
        self._onVisible?()
    }
    
    public func visibility() {
        self._onVisibility?()
    }
    
    public func invisible() {
        self.isVisible = false
        self._onInvisible?()
    }
    
    @discardableResult
    public func itemSize(_ value: SizeFloat) -> Self {
        self.itemSize = value
        return self
    }
    
    @discardableResult
    public func itemSpacing(_ value: Float) -> Self {
        self.itemSpacing = value
        return self
    }
    
    @discardableResult
    public func numberOfItem(_ value: UInt) -> Self {
        self.numberOfItem = value
        return self
    }
    
    @discardableResult
    public func rounding(_ value: RateViewRounding) -> Self {
        self.rounding = value
        return self
    }
    
    @discardableResult
    public func states(_ value: [RateViewState]) -> Self {
        self.states = value
        return self
    }
    
    @discardableResult
    public func rating(_ value: Float) -> Self {
        self.rating = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
        return self
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self.border = value
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self.shadow = value
        return self
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._onAppear = value
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._onDisappear = value
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._onVisible = value
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._onVisibility = value
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._onInvisible = value
        return self
    }
    
}

private extension RateView {
    
    static func _sort(states: [RateViewState]) -> [RateViewState] {
        return states.sorted(by: { $0.rate < $1.rate })
    }
    
}
