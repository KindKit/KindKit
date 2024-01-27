//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class RectView : IView, IViewSupportStaticSize, IViewSupportBorder, IViewSupportCornerRadius, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: StaticSize = .fill {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var border: Border = .none {
        didSet {
            guard self.border != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(border: self.border)
            }
        }
    }
    
    public var cornerRadius: CornerRadius = .none {
        didSet {
            guard self.cornerRadius != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(cornerRadius: self.cornerRadius)
            }
        }
    }
    
    @KindMonadicProperty
    public var fill: Color {
        didSet {
            guard self.fill != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(fill: self.fill)
            }
        }
    }
    
    public var color: Color = .clear {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(color: self.color)
            }
        }
    }
    
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(alpha: self.alpha)
            }
        }
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init(_ fill: Color) {
        self.fill = fill
        self._layout = .init(self)
    }
    
}

extension RectView : IViewSupportStyleSheet {
    
    public func apply(_ styleSheet: RectStyleSheet) -> Self {
        if let border = styleSheet.border {
            self.border = border
        }
        if let cornerRadius = styleSheet.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        if let fill = styleSheet.fill {
            self.fill = fill
        }
        if let color = styleSheet.color {
            self.color = color
        }
        if let alpha = styleSheet.alpha {
            self.alpha = alpha
        }
        return self
    }
    
}
