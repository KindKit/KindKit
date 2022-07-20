//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView
    
public final class GraphicsView : IGraphicsView {
    
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
    public var width: StaticSizeBehaviour {
        didSet(oldValue) {
            guard self.width != oldValue else { return }
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: StaticSizeBehaviour {
        didSet(oldValue) {
            guard self.height != oldValue else { return }
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var canvas: IGraphicsCanvas {
        willSet(oldValue) {
            guard self.canvas !== oldValue else { return }
            self.canvas.detach()
        }
        didSet(oldValue) {
            guard self.canvas !== oldValue else { return }
            self.canvas.attach(view: self)
            self._view.update(canvas: self.canvas)
        }
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
    public var color: Color? {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(color: self.color)
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
    private var _isLocked: Bool
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onChangeStyle: ((_ userInteraction: Bool) -> Void)?
    
    public init(
        width: StaticSizeBehaviour,
        height: StaticSizeBehaviour,
        canvas: IGraphicsCanvas,
        isLocked: Bool = false,
        color: Color? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.canvas = canvas
        self._isLocked = isLocked
        self.color = color
        self.alpha = alpha
        self.isHidden = isHidden
        self._reuse = ReuseItem()
        self._reuse.configure(owner: self)
        self.canvas.attach(view: self)
    }
    
    deinit {
        self._reuse.destroy()
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return StaticSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height
        )
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
    
    public func setNeedRedraw() {
        guard self.isAppeared == true else { return }
        self._view.setNeedsDisplay()
    }
    
    public func triggeredChangeStyle(_ userInteraction: Bool) {
        self._onChangeStyle?(userInteraction)
    }
    
    @discardableResult
    public func width(_ value: StaticSizeBehaviour) -> Self {
        self.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: StaticSizeBehaviour) -> Self {
        self.height = value
        return self
    }
    
    @discardableResult
    public func canvas(_ value: IGraphicsCanvas) -> Self {
        self.canvas = value
        return self
    }
    
    @discardableResult
    public func lock(_ value: Bool) -> Self {
        self.isLocked = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self.color = value
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
    
}
