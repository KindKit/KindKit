//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class SpaceLayout : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope?
    
    public private(set) var frame = Rect.zero
    
    @MonadicField
    public var value: Size {
        didSet {
            guard self.value != oldValue else { return }
            self.update()
        }
    }
    
    private var _frame: Rect = .zero
    
    public init(
        _ value: Size
    ) {
        self.value = value
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.value
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        self.frame = .init(origin: request.container.origin, size: self.value)
        return self.value
    }
    
    public func collect(_ collector: Collector) {
    }
    
}
