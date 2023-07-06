//
//  KindKit
//

import Foundation

extension UI.View.Button {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var inset: Inset = Inset(horizontal: 4, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var alignment: UI.View.Button.Alignment = .center {
            didSet { self.setNeedForceUpdate() }
        }
        var background: IUIView? {
            didSet { self.setNeedForceUpdate(self.background) }
        }
        var spinner: IUIView? {
            didSet { self.setNeedForceUpdate(self.spinner) }
        }
        var spinnerPosition: UI.View.Button.SpinnerPosition = .fill {
            didSet { self.setNeedForceUpdate() }
        }
        var spinnerAnimating: Bool = false {
            didSet { self.setNeedForceUpdate() }
        }
        var primary: IUIView? {
            didSet { self.setNeedForceUpdate(self.primary) }
        }
        var secondary: IUIView? {
            didSet { self.setNeedForceUpdate(self.secondary) }
        }
        var secondaryPosition: UI.View.Button.SecondaryPosition = .left {
            didSet { self.setNeedForceUpdate() }
        }
        var secondarySpacing: Double = 4 {
            didSet { self.setNeedForceUpdate() }
        }
        private var _cacheSpinnerSize: Size?
        private var _cacheSecondarySize: Size?
        private var _cachePrimarySize: Size?

        init() {
        }
        
        public func invalidate() {
            self._cacheSpinnerSize = nil
            self._cacheSecondarySize = nil
            self._cachePrimarySize = nil
        }
        
        public func invalidate(_ view: IUIView) {
            if self.spinner === view {
                self._cacheSpinnerSize = nil
            } else if self.secondary === view {
                self._cacheSecondarySize = nil
            } else if self.primary === view {
                self._cachePrimarySize = nil
            }
        }
        
        func layout(bounds: Rect) -> Size {
            let availableBounds = bounds.inset(self.inset)
            if let background = self.background {
                background.frame = bounds
            }
            if self.spinnerAnimating == true, let spinner = self.spinner {
                let spinnerSize = self._spinnerSize(availableBounds.size, view: spinner)
                switch self.spinnerPosition {
                case .fill:
                    spinner.frame = Rect(center: availableBounds.center, size: spinnerSize).integral
                case .secondary:
                    if let primary = self.primary {
                        if self.secondary != nil {
                            let primarySize = self._primarySize(availableBounds.size, view: primary)
                            let frames = self._frame(
                                bounds: availableBounds,
                                alignment: self.alignment,
                                primarySize: primarySize,
                                secondaryPosition: self.secondaryPosition,
                                secondarySpacing: self.secondarySpacing,
                                secondarySize: spinnerSize
                            )
                            spinner.frame = frames.secondary
                            primary.frame = frames.primary
                        } else {
                            spinner.frame = Rect(center: availableBounds.center, size: spinnerSize)
                        }
                    } else {
                        spinner.frame = Rect(center: availableBounds.center, size: spinnerSize)
                    }
                }
            } else if let primary = self.primary, let secondary = self.secondary {
                let primarySize = self._primarySize(availableBounds.size, view: primary)
                let secondarySize = self._secondarySize(availableBounds.size, view: secondary)
                let frames = self._frame(
                    bounds: availableBounds,
                    alignment: self.alignment,
                    primarySize: primarySize,
                    secondaryPosition: self.secondaryPosition,
                    secondarySpacing: self.secondarySpacing,
                    secondarySize: secondarySize
                )
                secondary.frame = frames.secondary
                primary.frame = frames.primary
            } else if let primary = self.primary {
                let primarySize = self._primarySize(availableBounds.size, view: primary)
                switch self.alignment {
                case .fill: primary.frame = availableBounds
                case .center: primary.frame = Rect(center: availableBounds.center, size: primarySize)
                }
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            var size = Size(width: 0, height: 0)
            let spinnerSize = self.spinner.flatMap({ return $0.size(available: available) })
            let primarySize = self.primary.flatMap({ return $0.size(available: available) })
            let secondarySize = self.secondary.flatMap({ return $0.size(available: available) })
            if self.spinnerAnimating == true, let spinnerSize = spinnerSize {
                switch self.spinnerPosition {
                case .fill:
                    size = spinnerSize
                case .secondary:
                    if let primarySize = primarySize {
                        if secondarySize != nil {
                            switch self.secondaryPosition {
                            case .top, .bottom:
                                size.width = max(primarySize.width, spinnerSize.width)
                                size.height = primarySize.height + self.secondarySpacing + spinnerSize.height
                            case .left, .right:
                                size.width += primarySize.width + self.secondarySpacing + spinnerSize.width
                                size.height = max(primarySize.height, spinnerSize.height)
                            }
                        } else {
                            size = spinnerSize
                        }
                    } else {
                        size = spinnerSize
                    }
                }
            } else if let primarySize = primarySize, let secondarySize = secondarySize {
                switch self.secondaryPosition {
                case .top, .bottom:
                    size.width = max(primarySize.width, secondarySize.width)
                    size.height = primarySize.height + self.secondarySpacing + secondarySize.height
                case .left, .right:
                    size.width = primarySize.width + self.secondarySpacing + secondarySize.width
                    size.height = max(primarySize.height, secondarySize.height)
                }
            } else if let primarySize = primarySize {
                size = primarySize
            }
            return size.inset(-self.inset)
        }
        
        func views(bounds: Rect) -> [IUIView] {
            var views: [IUIView] = []
            if let view = self.background {
                views.append(view)
            }
            if self.spinnerAnimating == true {
                if let view = self.spinner {
                    views.append(view)
                }
            } else {
                if let view = self.secondary {
                    views.append(view)
                }
                if let view = self.primary {
                    views.append(view)
                }
            }
            return views
        }
        
    }
    
}

private extension UI.View.Button.Layout {
    
    func _spinnerSize(_ available: Size, view: IUIView) -> Size {
        if let size = self._cacheSpinnerSize {
            return size
        }
        self._cacheSpinnerSize = view.size(available: available)
        return self._cacheSpinnerSize!
    }
    
    func _secondarySize(_ available: Size, view: IUIView) -> Size {
        if let size = self._cacheSecondarySize {
            return size
        }
        self._cacheSecondarySize = view.size(available: available)
        return self._cacheSecondarySize!
    }
    
    func _primarySize(_ available: Size, view: IUIView) -> Size {
        if let size = self._cachePrimarySize {
            return size
        }
        self._cachePrimarySize = view.size(available: available)
        return self._cachePrimarySize!
    }
    
    func _frame(
        bounds: Rect,
        alignment: UI.View.Button.Alignment,
        primarySize: Size,
        secondaryPosition: UI.View.Button.SecondaryPosition,
        secondarySpacing: Double,
        secondarySize: Size
    ) -> (secondary: Rect, primary: Rect) {
        switch alignment {
        case .fill:
            switch secondaryPosition {
            case .top:
                let splited = bounds.split(
                    bottom: primarySize.height
                )
                let primary = splited.bottom
                let secondary = splited.top
                return (
                    secondary: Rect(
                        center: secondary.center,
                        width: secondarySize.width,
                        height: secondary.height
                    ),
                    primary: Rect(
                        center: primary.center,
                        width: primarySize.width,
                        height: primary.height
                    )
                )
            case .left:
                let splited = bounds.split(
                    right: primarySize.width
                )
                let primary = splited.right
                let secondary = splited.left
                return (
                    secondary: Rect(
                        center: secondary.center,
                        width: secondary.width,
                        height: secondarySize.height
                    ),
                    primary: Rect(
                        center: primary.center,
                        width: primary.width,
                        height: primarySize.height
                    )
                )
            case .right:
                let splited = bounds.split(
                    left: primarySize.width
                )
                let primary = splited.left
                let secondary = splited.right
                return (
                    secondary: Rect(
                        center: secondary.center,
                        width: secondary.width,
                        height: secondarySize.height
                    ),
                    primary: Rect(
                        center: primary.center,
                        width: primary.width,
                        height: primarySize.height
                    )
                )
            case .bottom:
                let splited = bounds.split(
                    top: primarySize.height
                )
                let primary = splited.top
                let secondary = splited.bottom
                return (
                    secondary: Rect(
                        center: secondary.center,
                        width: secondarySize.width,
                        height: secondary.height
                    ),
                    primary: Rect(
                        center: primary.center,
                        width: primarySize.width,
                        height: primary.height
                    )
                )
            }
        case .center:
            let primary: Rect
            let secondary: Rect
            let baseline = Point(
                x: max(primarySize.width, secondarySize.width) / 2,
                y: max(primarySize.height, secondarySize.height) / 2
            )
            switch secondaryPosition {
            case .top:
                secondary = Rect(
                    x: (baseline.x - (secondarySize.width / 2)),
                    y: 0,
                    width: secondarySize.width,
                    height: secondarySize.height
                )
                primary = Rect(
                    x: (baseline.x - (primarySize.width / 2)),
                    y: secondarySize.height + secondarySpacing,
                    width: primarySize.width,
                    height: primarySize.height
                )
            case .left:
                secondary = Rect(
                    x: 0,
                    y: (baseline.y - (secondarySize.height / 2)),
                    width: secondarySize.width,
                    height: secondarySize.height
                )
                primary = Rect(
                    x: secondarySize.width + secondarySpacing,
                    y: (baseline.y - (primarySize.height / 2)),
                    width: primarySize.width,
                    height: primarySize.height
                )
            case .right:
                primary = Rect(
                    x: 0,
                    y: (baseline.y - (primarySize.height / 2)),
                    width: primarySize.width,
                    height: primarySize.height
                )
                secondary = Rect(
                    x: primarySize.width + secondarySpacing,
                    y: (baseline.y - (secondarySize.height / 2)),
                    width: secondarySize.width,
                    height: secondarySize.height
                )
            case .bottom:
                primary = Rect(
                    x: (baseline.x - (primarySize.width / 2)),
                    y: 0,
                    width: primarySize.width,
                    height: primarySize.height
                )
                secondary = Rect(
                    x: (baseline.x - (secondarySize.width / 2)),
                    y: primarySize.height + secondarySpacing,
                    width: secondarySize.width,
                    height: secondarySize.height
                )
            }
            let union = secondary.union(primary)
            let center = bounds.center
            let offset = Point(
                x: center.x - (union.width / 2),
                y: center.y - (union.height / 2)
            )
            return (
                secondary: Rect(center: secondary.center + offset, size: secondary.size),
                primary: Rect(center: primary.center + offset, size: primary.size)
            )
        }
    }
    
}
