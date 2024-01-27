//
//  KindKit
//

import KindGeometry

public final class EmptyLayout : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope?
    
    public private(set) var frame = Rect.zero
    
    public init() {
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return .zero
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        self.frame = .init(
            origin: request.container.origin,
            size: request.available
        )
        return .init(
            width: request.available.width.normalized,
            height: request.available.height.normalized
        )
    }
    
    public func collect(_ collector: Collector) {
    }
    
}
