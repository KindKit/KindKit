//
//  KindKit
//

import KindMath

public final class EmptyLayout : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner?
    
    public private(set) var frame = Rect.zero
    
    public init() {
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
