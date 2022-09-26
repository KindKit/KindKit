//
//  KindKit
//

import Foundation

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
        var background: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.background) }
        }
        var spinner: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.spinner) }
        }
        var spinnerPosition: UI.View.Button.SpinnerPosition = .fill {
            didSet { self.setNeedForceUpdate() }
        }
        var spinnerAnimating: Bool = false {
            didSet { self.setNeedForceUpdate() }
        }
        var primary: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.primary) }
        }
        var primaryInset: InsetFloat = Inset(horizontal: 4, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var secondary: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.secondary) }
        }
        var secondaryPosition: UI.View.Button.SecondaryPosition = .left {
            didSet { self.setNeedForceUpdate() }
        }
        var secondaryInset: InsetFloat = Inset(horizontal: 4, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        private var _cacheSpinnerSize: SizeFloat?
        private var _cacheSecondarySize: SizeFloat?
        private var _cachePrimarySize: SizeFloat?

        init() {
        }
        
        public func invalidate(item: UI.Layout.Item) {
            if self.spinner == item {
                self._cacheSpinnerSize = nil
            } else if self.secondary == item {
                self._cacheSecondarySize = nil
            } else if self.primary == item {
                self._cachePrimarySize = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let availableBounds = bounds.inset(self.inset)
            if let background = self.background {
                background.frame = bounds
            }
            if self.spinnerAnimating == true, let spinner = self.spinner {
                let spinnerSize = self._spinnerSize(availableBounds.size, item: spinner)
                switch self.spinnerPosition {
                case .fill:
                    spinner.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                case .secondary:
                    if let primary = self.primary {
                        if self.secondary != nil {
                            let primarySize = self._primarySize(availableBounds.size, item: primary)
                            let frames = self._frame(
                                bounds: availableBounds,
                                alignment: self.alignment,
                                secondaryPosition: self.secondaryPosition,
                                secondaryInset: self.secondaryInset,
                                secondarySize: spinnerSize,
                                primaryInset: self.primaryInset,
                                primarySize: primarySize
                            )
                            spinner.frame = frames.secondary.integral
                            primary.frame = frames.primary.integral
                        } else {
                            spinner.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                        }
                    } else {
                        spinner.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                    }
                }
            } else if let primary = self.primary, let secondary = self.secondary {
                let primarySize = self._primarySize(availableBounds.size, item: primary)
                let secondarySize = self._secondarySize(availableBounds.size, item: secondary)
                let frames = self._frame(
                    bounds: availableBounds,
                    alignment: self.alignment,
                    secondaryPosition: self.secondaryPosition,
                    secondaryInset: self.secondaryInset,
                    secondarySize: secondarySize,
                    primaryInset: self.primaryInset,
                    primarySize: primarySize
                )
                secondary.frame = frames.secondary.integral
                primary.frame = frames.primary.integral
            } else if let primary = self.primary {
                let primarySize = self._primarySize(availableBounds.size, item: primary)
                switch self.alignment {
                case .fill: primary.frame = availableBounds
                case .center: primary.frame = RectFloat(center: availableBounds.center, size: primarySize).integral
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            var size = SizeFloat(width: 0, height: 0)
            let spinnerSize = self.spinner.flatMap({ return $0.size(available: available) })
            let primarySize = self.primary.flatMap({ return $0.size(available: available) })
            let secondarySize = self.secondary.flatMap({ return $0.size(available: available) })
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
            if let item = self.background {
                items.append(item)
            }
            if self.spinnerAnimating == true {
                if let item = self.spinner {
                    items.append(item)
                }
            } else {
                if let item = self.secondary {
                    items.append(item)
                }
            }
            if let item = self.primary {
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
