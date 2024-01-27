//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class LayoutView< LayoutType : ILayout > : IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportColor, IViewSupportAlpha {
    
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
    
    @KindMonadicProperty
    public var clipsToBounds: Bool = true {
        didSet {
            guard self.clipsToBounds != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(clipsToBounds: self.clipsToBounds)
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
