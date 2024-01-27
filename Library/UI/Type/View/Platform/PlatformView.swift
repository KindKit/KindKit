//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout

public final class PlatformView : IView, IViewSupportDynamicSize, IViewSupportContent {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var content: NativeView {
        didSet {
            guard self.content !== oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(content: self.content)
            }
            self.updateLayout(force: true)
        }
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init(_ content: NativeView) {
        self.content = content
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            calculate: {
                return .init(self._layout.view.kk_sizeOf($0.cgSize))
            }
        )
    }
    
}
