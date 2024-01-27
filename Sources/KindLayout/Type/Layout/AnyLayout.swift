//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class AnyLayout : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        set { self.content.owner = newValue }
        get { self.content.owner }
    }
    
    public var frame: Rect {
        self.content.frame
    }
    
    @KindMonadicProperty
    public var content: ILayout {
        willSet {
            guard self.content !== newValue else { return }
            self.content.owner = nil
            self.content.parent = nil
        }
        didSet {
            guard self.content !== oldValue else { return }
            self.content.parent = self
            self.content.owner = self.owner
            self.update()
        }
    }
    
    public init(
        _ content: ILayout
    ) {
        self.content = content
        
        self.content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.content {
            self.content.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        return self.content.arrange(request)
    }
    
    public func collect(_ collector: Collector) {
        return self.content.collect(collector)
    }
    
}
