//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VSpaceLayout : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner?
    
    public private(set) var frame = Rect.zero
    
    @KindMonadicProperty
    public var value: Double {
        didSet {
            guard self.value != oldValue else { return }
            self.update()
        }
    }
    
    private var _frame: Rect = .zero
    
    public init(
        _ value: Double
    ) {
        self.value = value
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
