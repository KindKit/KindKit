//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class HSpaceLayout : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope?
    
    public private(set) var frame = Rect.zero
    
    @MonadicField
    public var value: Coordinate {
        didSet {
            guard self.value != oldValue else { return }
            self.update()
        }
    }
    
    private var _frame: Rect = .zero
    
    public init(
        _ value: Coordinate
    ) {
        self.value = value
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return .init(width: self.value, height: 0)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let size = Size(width: self.value, height: 0)
        self.frame = .init(origin: request.container.origin, size: size)
        return size
    }
    
    public func collect(_ collector: Collector) {
    }
    
}


