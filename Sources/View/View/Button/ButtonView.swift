//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public final class ButtonView : IButtonView {
    
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
    public var inset: InsetFloat {
        set(value) { self._layout.inset = value }
        get { return self._layout.inset }
    }
    public var width: DynamicSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var height: DynamicSizeBehaviour {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedForceLayout()
        }
    }
    public var alignment: ButtonViewAlignment {
        set(value) { self._layout.alignment = value }
        get { return self._layout.alignment }
    }
    public var backgroundView: IView {
        didSet { self._layout.backgroundItem = LayoutItem(view: self.backgroundView) }
    }
    public var spinnerPosition: ButtonViewSpinnerPosition {
        set(value) { self._layout.spinnerPosition = value }
        get { return self._layout.spinnerPosition }
    }
    public var spinnerAnimating: Bool {
        set(value) {
            self._layout.spinnerAnimating = value
            self.spinnerView?.animating(value)
        }
        get { return self._layout.spinnerAnimating }
    }
    public var spinnerView: ISpinnerView? {
        didSet { self._layout.spinnerItem = self.spinnerView.flatMap({ LayoutItem(view: $0) }) }
    }
    public var secondaryPosition: ButtonViewSecondaryPosition {
        set(value) { self._layout.secondaryPosition = value }
        get { return self._layout.secondaryPosition }
    }
    public var secondaryInset: InsetFloat {
        set(value) { self._layout.secondaryInset = value }
        get { return self._layout.secondaryInset }
    }
    public var secondaryView: IView? {
        didSet { self._layout.secondaryItem = self.secondaryView.flatMap({ LayoutItem(view: $0) }) }
    }
    public var primaryInset: InsetFloat {
        set(value) { self._layout.primaryInset = value }
        get { return self._layout.primaryInset }
    }
    public var primaryView: IView {
        didSet { self._layout.primaryItem = LayoutItem(view: self.primaryView) }
    }
    public var isHighlighted: Bool {
        set(value) { self._view.isHighlighted = value }
        get { return self._view.isHighlighted }
    }
    public var isLocked: Bool {
        set(value) { self._view.isLocked = value }
        get { return self._view.isLocked }
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
    private var _view: ControlView< Layout >
    private var _isSelected: Bool
    
    public init(
        inset: InsetFloat = InsetFloat(horizontal: 4, vertical: 4),
        width: DynamicSizeBehaviour = .fit,
        height: DynamicSizeBehaviour = .fit,
        alignment: ButtonViewAlignment = .center,
        backgroundView: IView,
        spinnerPosition: ButtonViewSpinnerPosition = .fill,
        spinnerView: ISpinnerView? = nil,
        spinnerAnimating: Bool = false,
        secondaryPosition: ButtonViewSecondaryPosition = .left,
        secondaryInset: InsetFloat = InsetFloat(horizontal: 4, vertical: 4),
        secondaryView: IView? = nil,
        primaryInset: InsetFloat = InsetFloat(horizontal: 4, vertical: 4),
        primaryView: IView,
        isLocked: Bool = false,
        isSelected: Bool = false,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.width = width
        self.height = height
        self.backgroundView = backgroundView
        self.spinnerView = spinnerView
        self.secondaryView = secondaryView
        self.primaryView = primaryView
        self._layout = Layout(
            inset: inset,
            alignment: alignment,
            backgroundItem: LayoutItem(view: backgroundView),
            spinnerPosition: spinnerPosition,
            spinnerItem: spinnerView.flatMap({ return LayoutItem(view: $0) }),
            spinnerAnimating: spinnerAnimating,
            secondaryPosition: secondaryPosition,
            secondaryInset: secondaryInset,
            secondaryItem: secondaryView.flatMap({ return LayoutItem(view: $0) }),
            primaryInset: primaryInset,
            primaryItem: LayoutItem(view: primaryView)
        )
        self._view = ControlView(
            contentLayout: self._layout,
            shouldHighlighting: true,
            isLocked: isLocked,
            shouldPressed: true,
            color: color,
            border: border,
            cornerRadius: cornerRadius,
            shadow: shadow,
            alpha: alpha,
            isHidden: isHidden
        )
        self._isSelected = isSelected
    }
    
    public func loadIfNeeded() {
        self._view.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard self.isHidden == false else { return .zero }
        return DynamicSizeBehaviour.apply(
            available: available,
            width: self.width,
            height: self.height,
            sizeWithWidth: { return self._view.size(available: Size(width: $0, height: available.height)) },
            sizeWithHeight: { return self._view.size(available: Size(width: available.width, height: $0)) },
            size: { return self._view.size(available: available) }
        )
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
    
    public func triggeredChangeStyle(_ userInteraction: Bool) {
        self._view.triggeredChangeStyle(userInteraction)
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
    public func onChangeStyle(_ value: ((_ userInteraction: Bool) -> Void)?) -> Self {
        self._view.onChangeStyle(value)
        return self
    }
    
    @discardableResult
    public func onPressed(_ value: (() -> Void)?) -> Self {
        self._view.onPressed(value)
        return self
    }
    
}

extension ButtonView {
    
    final class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var inset: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        var alignment: ButtonViewAlignment {
            didSet { self.setNeedForceUpdate() }
        }
        var backgroundItem: LayoutItem {
            didSet { self.setNeedForceUpdate(item: self.backgroundItem) }
        }
        var spinnerPosition: ButtonViewSpinnerPosition {
            didSet { self.setNeedForceUpdate() }
        }
        var spinnerItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.spinnerItem) }
        }
        var spinnerAnimating: Bool {
            didSet { self.setNeedForceUpdate() }
        }
        var secondaryPosition: ButtonViewSecondaryPosition {
            didSet { self.setNeedForceUpdate() }
        }
        var secondaryInset: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        var secondaryItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.secondaryItem) }
        }
        var primaryInset: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        var primaryItem: LayoutItem {
            didSet { self.setNeedForceUpdate(item: self.primaryItem) }
        }
        private var _cacheSpinnerSize: SizeFloat?
        private var _cacheSecondarySize: SizeFloat?
        private var _cachePrimarySize: SizeFloat?

        init(
            inset: InsetFloat,
            alignment: ButtonViewAlignment,
            backgroundItem: LayoutItem,
            spinnerPosition: ButtonViewSpinnerPosition,
            spinnerItem: LayoutItem?,
            spinnerAnimating: Bool,
            secondaryPosition: ButtonViewSecondaryPosition,
            secondaryInset: InsetFloat,
            secondaryItem: LayoutItem?,
            primaryInset: InsetFloat,
            primaryItem: LayoutItem
        ) {
            self.inset = inset
            self.alignment = alignment
            self.backgroundItem = backgroundItem
            self.spinnerPosition = spinnerPosition
            self.spinnerItem = spinnerItem
            self.spinnerAnimating = spinnerAnimating
            self.secondaryPosition = secondaryPosition
            self.secondaryInset = secondaryInset
            self.secondaryItem = secondaryItem
            self.primaryInset = primaryInset
            self.primaryItem = primaryItem
        }
        
        public func invalidate(item: LayoutItem) {
            if self.spinnerItem === item {
                self._cacheSpinnerSize = nil
            } else if self.secondaryItem === item {
                self._cacheSecondarySize = nil
            } else if self.primaryItem === item {
                self._cachePrimarySize = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let availableBounds = bounds.inset(self.inset)
            self.backgroundItem.frame = bounds
            if self.spinnerAnimating == true, let spinnerItem = self.spinnerItem {
                let spinnerSize = self._spinnerSize(availableBounds.size, item: spinnerItem)
                switch self.spinnerPosition {
                case .fill:
                    spinnerItem.frame = RectFloat(center: availableBounds.center, size: spinnerSize).integral
                case .secondary:
                    if self.secondaryItem != nil {
                        let primarySize = self._primarySize(availableBounds.size, item: self.primaryItem)
                        let frames = self._frame(
                            bounds: availableBounds,
                            alignment: self.alignment,
                            secondaryPosition: self.secondaryPosition,
                            secondaryInset: self.secondaryInset,
                            secondarySize: spinnerSize,
                            primaryInset: self.primaryInset,
                            primarySize: primarySize
                        )
                        spinnerItem.frame = frames.secondary.integral
                        self.primaryItem.frame = frames.primary.integral
                    } else {
                        spinnerItem.frame = RectFloat(center: availableBounds.center, size: spinnerSize).integral
                    }
                }
            } else if let secondaryItem = self.secondaryItem {
                let secondarySize = self._secondarySize(availableBounds.size, item: secondaryItem)
                let primarySize = self._primarySize(availableBounds.size, item: self.primaryItem)
                let frames = self._frame(
                    bounds: availableBounds,
                    alignment: self.alignment,
                    secondaryPosition: self.secondaryPosition,
                    secondaryInset: self.secondaryInset,
                    secondarySize: secondarySize,
                    primaryInset: self.primaryInset,
                    primarySize: primarySize
                )
                secondaryItem.frame = frames.secondary.integral
                self.primaryItem.frame = frames.primary.integral
            } else {
                let primarySize = self._primarySize(availableBounds.size, item: self.primaryItem)
                switch self.alignment {
                case .fill: self.primaryItem.frame = availableBounds
                case .center: self.primaryItem.frame = RectFloat(center: availableBounds.center, size: primarySize).integral
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            var size = SizeFloat(width: 0, height: 0)
            let spinnerSize = self.spinnerItem.flatMap({ return $0.size(available: available) })
            let secondarySize = self.secondaryItem.flatMap({ return $0.size(available: available) })
            let primarySize = self.primaryItem.size(available: available)
            if self.spinnerAnimating == true, let spinnerSize = spinnerSize {
                switch self.spinnerPosition {
                case .fill:
                    size.width = self.inset.left + spinnerSize.width + self.inset.right
                    size.height = self.inset.top + spinnerSize.height + self.inset.bottom
                case .secondary:
                    if secondarySize != nil {
                        switch self.secondaryPosition {
                        case .top:
                            size.width = self.inset.left + max(spinnerSize.width, primarySize.width) + self.inset.right
                            size.height = self.inset.top + spinnerSize.height + self.secondaryInset.bottom + self.primaryInset.top + primarySize.height + self.inset.bottom
                        case .left:
                            size.width += self.inset.left + spinnerSize.width + self.secondaryInset.right + self.primaryInset.left + primarySize.width + self.inset.right
                            size.height = self.inset.top + max(spinnerSize.height, primarySize.height) + self.inset.bottom
                        case .right:
                            size.width = self.inset.left + primarySize.width + self.primaryInset.right + self.secondaryInset.left + spinnerSize.width + self.inset.right
                            size.height = self.inset.top + max(spinnerSize.height, primarySize.height) + self.inset.bottom
                        case .bottom:
                            size.width = self.inset.left + max(spinnerSize.width, primarySize.width) + self.inset.right
                            size.height = self.inset.top + primarySize.height + self.primaryInset.bottom + self.secondaryInset.top + spinnerSize.height + self.inset.bottom
                        }
                    } else {
                        size.width = self.inset.left + spinnerSize.width + self.inset.right
                        size.height = self.inset.top + spinnerSize.height + self.inset.bottom
                    }
                }
            } else if let secondarySize = secondarySize {
                switch self.secondaryPosition {
                case .top:
                    size.width = self.inset.left + max(secondarySize.width, primarySize.width) + self.inset.right
                    size.height = self.inset.top + secondarySize.height + self.secondaryInset.bottom + self.primaryInset.top + primarySize.height + self.inset.bottom
                case .left:
                    size.width = self.inset.left + secondarySize.width + self.secondaryInset.right + self.primaryInset.left + primarySize.width + self.inset.right
                    size.height = self.inset.top + max(secondarySize.height, primarySize.height) + self.inset.bottom
                case .right:
                    size.width = self.inset.left + primarySize.width + self.primaryInset.right + self.secondaryInset.left + secondarySize.width + self.inset.right
                    size.height = self.inset.top + max(secondarySize.height, primarySize.height) + self.inset.bottom
                case .bottom:
                    size.width = self.inset.left + max(secondarySize.width, primarySize.width) + self.inset.right
                    size.height = self.inset.top + primarySize.height + self.primaryInset.bottom + self.secondaryInset.top + secondarySize.height + self.inset.bottom
                }
            } else {
                size.width = self.inset.left + primarySize.width + self.inset.right
                size.height = self.inset.top + primarySize.height + self.inset.bottom
            }
            return size
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            var items: [LayoutItem] = [ self.backgroundItem ]
            if self.spinnerAnimating == true {
                if let item = self.spinnerItem {
                    items.append(item)
                }
            } else {
                if let item = self.secondaryItem {
                    items.append(item)
                }
                items.append(self.primaryItem)
            }
            return items
        }
        
    }
    
}

private extension ButtonView.Layout {
    
    func _spinnerSize(_ available: SizeFloat, item: LayoutItem) -> SizeFloat {
        if let size = self._cacheSpinnerSize {
            return size
        }
        self._cacheSpinnerSize = item.size(available: available)
        return self._cacheSpinnerSize!
    }
    
    func _secondarySize(_ available: SizeFloat, item: LayoutItem) -> SizeFloat {
        if let size = self._cacheSecondarySize {
            return size
        }
        self._cacheSecondarySize = item.size(available: available)
        return self._cacheSecondarySize!
    }
    
    func _primarySize(_ available: SizeFloat, item: LayoutItem) -> SizeFloat {
        if let size = self._cachePrimarySize {
            return size
        }
        self._cachePrimarySize = item.size(available: available)
        return self._cachePrimarySize!
    }
    
    func _frame(bounds: RectFloat, alignment: ButtonViewAlignment, secondaryPosition: ButtonViewSecondaryPosition, secondaryInset: InsetFloat, secondarySize: SizeFloat, primaryInset: InsetFloat, primarySize: SizeFloat) -> (secondary: RectFloat, primary: RectFloat) {
        let secondary: RectFloat
        let primary: RectFloat
        switch secondaryPosition {
        case .top:
            let offset = secondaryInset.top + secondarySize.height + primaryInset.top
            let baseline = max(secondarySize.width, primarySize.width) / 2
            secondary = RectFloat(
                x: baseline - (secondarySize.width / 2),
                y: 0,
                width: secondarySize.width,
                height: secondarySize.height
            )
            switch alignment {
            case .fill:
                primary = RectFloat(
                    x: baseline - (primarySize.width / 2),
                    y: offset,
                    width: primarySize.width,
                    height: bounds.height - offset
                )
            case .center:
                primary = RectFloat(
                    x: baseline - (primarySize.width / 2),
                    y: offset,
                    width: primarySize.width,
                    height: primarySize.height
                )
            }
        case .left:
            let offset = secondaryInset.right + secondarySize.width + primaryInset.left
            let baseline = max(secondarySize.height, primarySize.height) / 2
            secondary = RectFloat(
                x: 0,
                y: baseline - (secondarySize.height / 2),
                width: secondarySize.width,
                height: secondarySize.height
            )
            switch alignment {
            case .fill:
                primary = RectFloat(
                    x: offset,
                    y: baseline - (primarySize.height / 2),
                    width: bounds.width - offset,
                    height: primarySize.height
                )
            case .center:
                primary = RectFloat(
                    x: offset,
                    y: baseline - (primarySize.height / 2),
                    width: primarySize.width,
                    height: primarySize.height
                )
            }
        case .right:
            let offset = secondaryInset.left + primarySize.width + primaryInset.right
            let baseline = max(secondarySize.height, primarySize.height) / 2
            secondary = RectFloat(
                x: offset,
                y: baseline - (secondarySize.height / 2),
                width: secondarySize.width,
                height: secondarySize.height
            )
            switch alignment {
            case .fill:
                primary = RectFloat(
                    x: 0,
                    y: baseline - (primarySize.height / 2),
                    width: bounds.width - offset,
                    height: primarySize.height
                )
            case .center:
                primary = RectFloat(
                    x: 0,
                    y: baseline - (primarySize.height / 2),
                    width: primarySize.width,
                    height: primarySize.height
                )
            }
        case .bottom:
            let offset = secondaryInset.top + primarySize.height + primaryInset.bottom
            let baseline = max(secondarySize.width, primarySize.width) / 2
            secondary = RectFloat(
                x: baseline - (secondarySize.width / 2),
                y: offset,
                width: secondarySize.width,
                height: secondarySize.height
            )
            switch alignment {
            case .fill:
                primary = RectFloat(
                    x: baseline - (primarySize.width / 2),
                    y: 0,
                    width: primarySize.width,
                    height: bounds.height - offset
                )
            case .center:
                primary = RectFloat(
                    x: baseline - (primarySize.width / 2),
                    y: 0,
                    width: primarySize.width,
                    height: primarySize.height
                )
            }
        }
        let union = secondary.union(primary)
        let center = bounds.center
        let offset = PointFloat(
            x: center.x - (union.width / 2),
            y: center.y - (union.height / 2)
        )
        return (
            secondary: RectFloat(center: secondary.center + offset, size: secondary.size),
            primary: RectFloat(center: primary.center + offset, size: primary.size)
        )
    }
    
}
