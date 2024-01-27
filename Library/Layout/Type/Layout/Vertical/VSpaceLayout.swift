//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class VSpaceLayout : Layout {
    
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
        return .init(width: 0, height: self.value)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let size = Size(width: 0, height: self.value)
        self.frame = .init(origin: request.container.origin, size: size)
        return size
    }
    
    public func collect(_ collector: Collector) {
    }
    
}
