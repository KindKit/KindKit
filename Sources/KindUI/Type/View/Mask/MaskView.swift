//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

public final class MaskView< LayoutType : ILayout > : IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportBorder, IViewSupportCornerRadius, IViewSupportShadow, IViewSupportColor, IViewSupportAlpha {
    
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
    
    @KindMonadicProperty(default: EmptyLayout.self)
    public var content: LayoutType {
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
    
    private var _layout: ReuseRootLayoutItem< Reusable, LayoutType >!
    
    public init(
        _ content: ContentType
    ) {
        self.content = content
        self._layout = .init(self)
        self._layout.manager.content = content
    }
    
    public convenience init< InitType: ILayout >(
        _ content: InitType
    ) where ContentType == AnyLayout {
        self.init(.init(content))
    }
    
    public convenience init(
        _ view: any IView
    ) where ContentType == AnyViewLayout {
        self.init(.init(view))
    }
    
    public convenience init< ViewType: IView >(
        _ view: ViewType
    ) where ContentType == ViewLayout< ViewType > {
        self.init(.init(view))
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self._layout.sizeOf(request)
    }

}
