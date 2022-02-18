//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class BarItemView : IBarItemView {
    
    public var layout: ILayout? {
        get { return self._view.layout }
    }
    public unowned var item: LayoutItem? {
        set(value) { self._view.item = value }
        get { return self._view.item }
    }
    public var native: NativeView {
        return self._view.native
    }
    public var isLoaded: Bool {
        return self._view.isLoaded
    }
    public var bounds: RectFloat {
        return self._view.bounds
    }
    public var isVisible: Bool {
        return self._view.isVisible
    }
    public var isHidden: Bool {
        set(value) { self._view.isHidden = value }
        get { return self._view.isHidden }
    }
    public unowned var delegate: IBarItemViewDelegate?
    public var contentInset: InsetFloat {
        set(value) { self._layout.contentInset = value }
        get { return self._layout.contentInset }
    }
    public var contentView: IView {
        didSet(oldValue) {
            guard self.contentView !== oldValue else { return }
            self._layout.contentItem = LayoutItem(view: self.contentView)
        }
    }
    public var isHighlighted: Bool {
        set(value) { self._view.isHighlighted = value }
        get { return self._view.isHighlighted }
    }
    public var isSelected: Bool {
        set(value) {
            if self._isSelected != value {
                self._isSelected = value
                self.triggeredChangeStyle(false)
            }
        }
        get { return self._isSelected }
    }
    public var color: Color? {
        set(value) { self._view.color = value }
        get { return self._view.color }
    }
    public var cornerRadius: ViewCornerRadius {
        set(value) { self._view.cornerRadius = value }
        get { return self._view.cornerRadius }
    }
    public var border: ViewBorder {
        set(value) { self._view.border = value }
        get { return self._view.border }
    }
    public var shadow: ViewShadow? {
        set(value) { self._view.shadow = value }
        get { return self._view.shadow }
    }
    public var alpha: Float {
        set(value) { self._view.alpha = value }
        get { return self._view.alpha }
    }
    
    private var _layout: Layout
    private var _view: CustomView< Layout >
    private var _tapGesture: ITapGesture
    private var _isSelected: Bool
    
    public init(
        contentInset: InsetFloat = InsetFloat(horizontal: 8, vertical: 4),
        contentView: IView,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.contentView = contentView
        self._layout = Layout(
            contentInset: contentInset,
            contentItem: LayoutItem(view: contentView)
        )
        self._tapGesture = TapGesture()
        self._isSelected = false
        self._view = CustomView(
            gestures: [ self._tapGesture ],
            contentLayout: self._layout,
            shouldHighlighting: true,
            isHighlighted: false,
            color: color,
            border: border,
            cornerRadius: cornerRadius,
            shadow: shadow,
            alpha: alpha,
            isHidden: isHidden
        )
        self._init()
    }
    
    public func loadIfNeeded() {
        self._view.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self._view.size(available: available)
    }
    
    public func appear(to layout: ILayout) {
        self._view.appear(to: layout)
    }
    
    public func disappear() {
        self._view.disappear()
    }
    
    public func visible() {
        self._view.visible()
    }
    
    public func visibility() {
        self._view.visibility()
    }
    
    public func invisible() {
        self._view.invisible()
    }
    
    public func triggeredChangeStyle(_ userIteraction: Bool) {
        self._view.triggeredChangeStyle(userIteraction)
    }
    
    @discardableResult
    public func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
    @discardableResult
    public func contentView(_ value: IView) -> Self {
        self.contentView = value
        return self
    }
    
    @discardableResult
    public func highlight(_ value: Bool) -> Self {
        self._view.highlight(value)
        return self
    }
    
    @discardableResult
    public func select(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }
    
    @discardableResult
    public func color(_ value: Color?) -> Self {
        self._view.color(value)
        return self
    }
    
    @discardableResult
    public func border(_ value: ViewBorder) -> Self {
        self._view.border(value)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self._view.cornerRadius(value)
        return self
    }
    
    @discardableResult
    public func shadow(_ value: ViewShadow?) -> Self {
        self._view.shadow(value)
        return self
    }
    
    @discardableResult
    public func alpha(_ value: Float) -> Self {
        self._view.alpha(value)
        return self
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self._view.hidden(value)
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._view.onAppear(value)
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._view.onDisappear(value)
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._view.onVisible(value)
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._view.onVisibility(value)
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._view.onInvisible(value)
        return self
    }
    
    @discardableResult
    public func onChangeStyle(_ value: ((Bool) -> Void)?) -> Self {
        self._view.onChangeStyle(value)
        return self
    }
    
}

private extension BarItemView {
    
    func _init() {
        self._tapGesture.onTriggered({ [weak self] in
            guard let self = self else { return }
            self.delegate?.pressed(barItemView: self)
        })
    }
    
}

private extension BarItemView {
    
    class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var contentInset: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        var contentItem: LayoutItem {
            didSet { self.setNeedForceUpdate(item: self.contentItem) }
        }
        
        init(
            contentInset: InsetFloat,
            contentItem: LayoutItem
        ) {
            self.contentInset = contentInset
            self.contentItem = contentItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.contentItem.frame = bounds.inset(self.contentInset)
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.contentItem.size(available: available.inset(self.contentInset))
            let contentBounds = contentSize.inset(-self.contentInset)
            return contentBounds
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            return [ self.contentItem ]
        }
        
    }
    
}
