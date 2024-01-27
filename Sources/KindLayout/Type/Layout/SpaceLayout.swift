//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class SpaceLayout : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner?
    
    public private(set) var frame = Rect.zero
    
    @KindMonadicProperty
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
    
    public func invalidate(_ layout: ILayout) {
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
