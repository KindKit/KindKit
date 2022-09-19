//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Button : IUIWidgetView, IUIViewDynamicSizeable, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewPressable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var inset: InsetFloat {
            set(value) { self._layout.inset = value }
            get { return self._layout.inset }
        }
        public var width: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var alignment: Alignment {
            set(value) { self._layout.alignment = value }
            get { return self._layout.alignment }
        }
        public var backgroundView: IUIView? {
            didSet { self._layout.backgroundItem = self.backgroundView.flatMap({ UI.Layout.Item($0) }) }
        }
        public var spinnerPosition: SpinnerPosition {
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
        public var spinnerView: (IUIView & IUIViewAnimatable)? {
            didSet { self._layout.spinnerItem = self.spinnerView.flatMap({ UI.Layout.Item($0) }) }
        }
        public var secondaryPosition: SecondaryPosition {
            set(value) { self._layout.secondaryPosition = value }
            get { return self._layout.secondaryPosition }
        }
        public var secondaryInset: InsetFloat {
            set(value) { self._layout.secondaryInset = value }
            get { return self._layout.secondaryInset }
        }
        public var secondaryView: IUIView? {
            didSet { self._layout.secondaryItem = self.secondaryView.flatMap({ UI.Layout.Item($0) }) }
        }
        public var primaryInset: InsetFloat {
            set(value) { self._layout.primaryInset = value }
            get { return self._layout.primaryInset }
        }
        public var primaryView: IUIView? {
            didSet { self._layout.primaryItem = self.primaryView.flatMap({ UI.Layout.Item($0) }) }
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
        public private(set) var body: UI.View.Control
        
        private var _layout: Layout
        private var _isSelected: Bool = false
        
        public init() {
            self._layout = Layout()
            self.body = .init(self._layout)
                .shouldHighlighting(true)
                .shouldPressed(true)
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Dynamic.apply(
                available: available,
                width: self.width,
                height: self.height,
                sizeWithWidth: { return self.body.size(available: Size(width: $0, height: available.height)) },
                sizeWithHeight: { return self.body.size(available: Size(width: available.width, height: $0)) },
                size: { return self.body.size(available: available) }
            )
        }
        
    }
    
}

public extension UI.View.Button {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func backgroundView(_ value: IUIView?) -> Self {
        self.backgroundView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: SpinnerPosition) -> Self {
        self.spinnerPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerAnimating(_ value: Bool) -> Self {
        self.spinnerAnimating = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerView(_ value: (IUIView & IUIViewAnimatable)?) -> Self {
        self.spinnerView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primaryInset(_ value: InsetFloat) -> Self {
        self.primaryInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primaryView(_ value: IUIView?) -> Self {
        self.primaryView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: SecondaryPosition) -> Self {
        self.secondaryPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryInset(_ value: InsetFloat) -> Self {
        self.secondaryInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryView(_ value: IUIView?) -> Self {
        self.secondaryView = value
        return self
    }
    
}

extension UI.View.Button {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var inset: InsetFloat = Inset(horizontal: 4, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var alignment: UI.View.Button.Alignment = .center {
            didSet { self.setNeedForceUpdate() }
        }
        var backgroundItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.backgroundItem) }
        }
        var spinnerPosition: UI.View.Button.SpinnerPosition = .fill {
            didSet { self.setNeedForceUpdate() }
        }
        var spinnerItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.spinnerItem) }
        }
        var spinnerAnimating: Bool = false {
            didSet { self.setNeedForceUpdate() }
        }
        var primaryInset: InsetFloat = Inset(horizontal: 4, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var primaryItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.primaryItem) }
        }
        var secondaryPosition: UI.View.Button.SecondaryPosition = .left {
            didSet { self.setNeedForceUpdate() }
        }
        var secondaryInset: InsetFloat = Inset(horizontal: 4, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var secondaryItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.secondaryItem) }
        }
        private var _cacheSpinnerSize: SizeFloat?
        private var _cacheSecondarySize: SizeFloat?
        private var _cachePrimarySize: SizeFloat?

        init() {
        }
        
        public func invalidate(item: UI.Layout.Item) {
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
            if let backgroundItem = self.backgroundItem {
                backgroundItem.frame = bounds
            }
            if self.spinnerAnimating == true, let spinnerItem = self.spinnerItem {
                let spinnerSize = self._spinnerSize(availableBounds.size, item: spinnerItem)
                switch self.spinnerPosition {
                case .fill:
                    spinnerItem.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                case .secondary:
                    if let primaryItem = self.primaryItem {
                        if self.secondaryItem != nil {
                            let primarySize = self._primarySize(availableBounds.size, item: primaryItem)
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
                            primaryItem.frame = frames.primary.integral
                        } else {
                            spinnerItem.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                        }
                    } else {
                        spinnerItem.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                    }
                }
            } else if let primaryItem = self.primaryItem, let secondaryItem = self.secondaryItem {
                let primarySize = self._primarySize(availableBounds.size, item: primaryItem)
                let secondarySize = self._secondarySize(availableBounds.size, item: secondaryItem)
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
                primaryItem.frame = frames.primary.integral
            } else if let primaryItem = self.primaryItem {
                let primarySize = self._primarySize(availableBounds.size, item: primaryItem)
                switch self.alignment {
                case .fill: primaryItem.frame = availableBounds
                case .center: primaryItem.frame = RectFloat(center: availableBounds.center, size: primarySize).integral
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            var size = SizeFloat(width: 0, height: 0)
            let spinnerSize = self.spinnerItem.flatMap({ return $0.size(available: available) })
            let secondarySize = self.secondaryItem.flatMap({ return $0.size(available: available) })
            let primarySize = self.primaryItem.flatMap({ return $0.size(available: available) })
            if self.spinnerAnimating == true, let spinnerSize = spinnerSize {
                switch self.spinnerPosition {
                case .fill:
                    size.width = self.inset.left + spinnerSize.width + self.inset.right
                    size.height = self.inset.top + spinnerSize.height + self.inset.bottom
                case .secondary:
                    if let primarySize = primarySize {
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
                    } else {
                        size.width = self.inset.left + spinnerSize.width + self.inset.right
                        size.height = self.inset.top + spinnerSize.height + self.inset.bottom
                    }
                }
            } else if let primarySize = primarySize, let secondarySize = secondarySize {
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
            } else if let primarySize = primarySize {
                size.width = self.inset.left + primarySize.width + self.inset.right
                size.height = self.inset.top + primarySize.height + self.inset.bottom
            }
            return size
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = []
            if let item = self.backgroundItem {
                items.append(item)
            }
            if self.spinnerAnimating == true {
                if let item = self.spinnerItem {
                    items.append(item)
                }
            } else {
                if let item = self.secondaryItem {
                    items.append(item)
                }
            }
            if let item = self.primaryItem {
                items.append(item)
            }
            return items
        }
        
    }
    
}

private extension UI.View.Button.Layout {
    
    func _spinnerSize(_ available: SizeFloat, item: UI.Layout.Item) -> SizeFloat {
        if let size = self._cacheSpinnerSize {
            return size
        }
        self._cacheSpinnerSize = item.size(available: available)
        return self._cacheSpinnerSize!
    }
    
    func _secondarySize(_ available: SizeFloat, item: UI.Layout.Item) -> SizeFloat {
        if let size = self._cacheSecondarySize {
            return size
        }
        self._cacheSecondarySize = item.size(available: available)
        return self._cacheSecondarySize!
    }
    
    func _primarySize(_ available: SizeFloat, item: UI.Layout.Item) -> SizeFloat {
        if let size = self._cachePrimarySize {
            return size
        }
        self._cachePrimarySize = item.size(available: available)
        return self._cachePrimarySize!
    }
    
    func _frame(
        bounds: RectFloat,
        alignment: UI.View.Button.Alignment,
        secondaryPosition: UI.View.Button.SecondaryPosition,
        secondaryInset: InsetFloat,
        secondarySize: SizeFloat,
        primaryInset: InsetFloat,
        primarySize: SizeFloat
    ) -> (secondary: RectFloat, primary: RectFloat) {
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
