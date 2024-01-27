//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout

public final class ColorView : IView, IViewSupportStaticSize, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: StaticSize = .fill {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
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
    
    public init(_ color: Color) {
        self.color = color
        self._layout = .init(self)
    }

}

extension ColorView : IViewSupportStyleSheet {
    
    public func apply(_ styleSheet: ColorStyleSheet) -> Self {
        if let color = styleSheet.color {
            self.color = color
        }
        if let alpha = styleSheet.alpha {
            self.alpha = alpha
        }
        return self
    }
    
}
