//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

protocol NativeControlViewDelegate : AnyObject {
    
    func shouldHighlighting(view: NativeControlView) -> Bool
    func set(view: NativeControlView, highlighted: Bool)
    
    func shouldPressing(view: NativeControlView) -> Bool
    func pressed(view: NativeControlView)
    
}

public class ControlView< Layout : ILayout > : IControlView {
    
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
    public var contentLayout: Layout {
        willSet {
            self.contentLayout.view = nil
        }
        didSet(oldValue) {
            self.contentLayout.view = self
            guard self.isLoaded == true else { return }
            self._view.update(contentLayout: self.contentLayout)
            self.contentLayout.setNeedForceUpdate()
        }
    }
    public var contentSize: SizeFloat {
        get {
            guard self.isLoaded == true else { return .zero }
            return self._view.contentSize
        }
    }
    public var shouldHighlighting: Bool {
        didSet {
            if self.shouldHighlighting == false {
                self.isHighlighted = false
            }
        }
    }
    public var isHighlighted: Bool {
        set(value) {
            if self._isHighlighted != value {
                self._isHighlighted = value
                self.triggeredChangeStyle(false)
            }
        }
        get { return self._isHighlighted }
    }
    public var isLocked: Bool {
        set(value) {
            if self._isLocked != value {
                self._isLocked = value
                if self.isLoaded == true {
                    self._view.update(locked: self._isLocked)
                }
                self.triggeredChangeStyle(false)
            }
        }
        get { return self._isLocked }
    }
    public var shouldPressed: Bool
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
        }
    }
    public var cornerRadius: ViewCornerRadius {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(cornerRadius: self.cornerRadius)
            self._view.updateShadowPath()
        }
    }
    public var border: ViewBorder {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(border: self.border)
        }
    }
    public var shadow: ViewShadow? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(shadow: self.shadow)
            self._view.updateShadowPath()
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
    private var _isHighlighted: Bool
    private var _isLocked: Bool
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onChangeStyle: ((_ userInteraction: Bool) -> Void)?
    private var _onPressed: (() -> Void)?
    
    public init(
        contentLayout: Layout,
        shouldHighlighting: Bool = false,
        isHighlighted: Bool = false,
        isLocked: Bool = false,
        shouldPressed: Bool = false,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.contentLayout = contentLayout
        self.shouldHighlighting = shouldHighlighting
        self._isHighlighted = shouldHighlighting == true && isHighlighted == true
        self._isLocked = isLocked
        self.shouldPressed = shouldPressed
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
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
        return self.contentLayout.size(available: available)
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
    
    public func triggeredChangeStyle(_ userInteraction: Bool) {
        self._onChangeStyle?(userInteraction)
    }
    
    @discardableResult
    public func contentLayout(_ value: Layout) -> Self {
        self.contentLayout = value
        return self
    }
    
    @discardableResult
    public func shouldHighlighting(_ value: Bool) -> Self {
        self.shouldHighlighting = value
        return self
    }
    
    @discardableResult
    public func highlight(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }
    
    @discardableResult
    public func lock(_ value: Bool) -> Self {
        self.isLocked = value
        return self
    }
    
    @discardableResult
    public func shouldPressed(_ value: Bool) -> Self {
        self.shouldPressed = value
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
    
    @discardableResult
    public func onChangeStyle(_ value: ((_ userInteraction: Bool) -> Void)?) -> Self {
        self._onChangeStyle = value
        return self
    }
    
    @discardableResult
    public func onPressed(_ value: (() -> Void)?) -> Self {
        self._onPressed = value
        return self
    }
    
}

extension ControlView : NativeControlViewDelegate {
    
    func shouldHighlighting(view: NativeControlView) -> Bool {
        return self.shouldHighlighting
    }
    
    func set(view: NativeControlView, highlighted: Bool) {
        if self._isHighlighted != highlighted {
            self._isHighlighted = highlighted
            self._onChangeStyle?(true)
        }
    }
    
    func shouldPressing(view: NativeControlView) -> Bool {
        return self.shouldPressed
    }
    
    func pressed(view: NativeControlView) {
        self._onPressed?()
    }
    
}
