//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@Monadic
public final class MaskView< Layout : ILayout > : IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportBorder, IViewSupportCornerRadius, IViewSupportShadow, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self._layout.manager.available = self.size
            self.updateLayout(force: true)
        }
    }
    
    @MonadicField(default: EmptyLayout.self)
    public var content: Layout {
        didSet {
            guard self.content !== oldValue else { return }
            self._layout.manager.content = self.content
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
    
    public var shadow: Shadow? {
        didSet {
            guard self.shadow != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(shadow: self.shadow)
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
    
    var holder: IHolder? {
        set { self._layout.manager.holder = newValue }
        get { self._layout.manager.holder }
    }
    
    private var _layout: ReuseRootLayoutItem< Reusable, Layout >!
    
    public init(
        _ content: Content
    ) {
        self.content = content
        self._layout = .init(self)
        self._layout.manager.content = content
    }
    
    public convenience init< Init: ILayout >(
        _ content: Init
    ) where Content == AnyLayout {
        self.init(.init(content))
    }
    
    public convenience init(
        _ view: any IView
    ) where Content == AnyViewLayout {
        self.init(.init(view))
    }
    
    public convenience init< View: IView >(
        _ view: View
    ) where Content == ViewLayout< View > {
        self.init(.init(view))
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self._layout.sizeOf(request)
    }

}

extension MaskView : IViewSupportStyleSheet {
    
    public func apply(_ styleSheet: MaskStyleSheet) -> Self {
        if let border = styleSheet.border {
            self.border = border
        }
        if let cornerRadius = styleSheet.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        if let shadow = styleSheet.shadow {
            self.shadow = shadow
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
