//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class RectView : IView, IViewStaticSizeable, IViewBorderable, IViewCornerRadiusable, IViewColorable, IViewAlphable {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return self._layout.isLoaded
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
    
    public var color: Color? {
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
    
    @KindMonadicProperty
    public var fill: Color? {
        didSet {
            guard self.fill != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(fill: self.fill)
            }
        }
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
        self._layout = .init(self)
    }
    
}
