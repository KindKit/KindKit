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
    
    private let _layout = EmptyLayoutItem()
    
    public init() {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return .zero
    }

}
