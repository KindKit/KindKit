//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

protocol SwitchViewDelegate : AnyObject {
    
    func changed(value: Bool)
    
}

public class SwitchView : ISwitchView {
        
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
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: StaticSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var thumbColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(thumbColor: self.thumbColor)
        }
    }
    public var offColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(offColor: self.offColor)
        }
    }
    public var onColor: Color {
        didSet {
            guard self.isLoaded == true else { return }
            self._view.update(onColor: self.onColor)
        }
    }
    public var value: Bool {
        set(value) {
            self._value = value
            guard self.isLoaded == true else { return }
            self._view.update(value: self._value)
        }
        get { return self._value }
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
    private var _isLocked: Bool
    private var _value: Bool
    private var _onAppear: (() -> Void)?
    private var _onDisappear: (() -> Void)?
    private var _onVisible: (() -> Void)?
    private var _onVisibility: (() -> Void)?
    private var _onInvisible: (() -> Void)?
    private var _onChangeStyle: ((_ userIteraction: Bool) -> Void)?
    private var _onChangeValue: (() -> Void)?
    
    public init(
        width: StaticSizeBehaviour = .fill,
        height: StaticSizeBehaviour,
        thumbColor: Color,
        offColor: Color,
        onColor: Color,
        value: Bool,
        isLocked: Bool = false,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.isVisible = false
        self.width = width
        self.height = height
        self.thumbColor = thumbColor
        self.offColor = offColor
        self.onColor = onColor
        self._value = value
        self._isLocked = isLocked
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
    
    public func triggeredChangeStyle(_ userIteraction: Bool) {
        self._onChangeStyle?(userIteraction)
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
    public func thumbColor(_ value: Color) -> Self {
        self.thumbColor = value
        return self
    }
    
    @discardableResult
    public func offColor(_ value: Color) -> Self {
        self.offColor = value
        return self
    }
    
    @discardableResult
    public func onColor(_ value: Color) -> Self {
        self.onColor = value
        return self
    }
    
    @discardableResult
    public func value(_ value: Bool) -> Self {
        self.value = value
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
    public func onChangeStyle(_ value: ((_ userIteraction: Bool) -> Void)?) -> Self {
        self._onChangeStyle = value
        return self
    }
    
    @discardableResult
    public func onChangeValue(_ value: (() -> Void)?) -> Self {
        self._onChangeValue = value
        return self
    }
    
}

extension SwitchView : SwitchViewDelegate {
    
    func changed(value: Bool) {
        self._value = value
        self._onChangeValue?()
    }
    
}
