//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout

public final class EmptyView : IView {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
        self._layout = .init(self)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return .zero
    }

}
