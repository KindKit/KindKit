//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class HFillLayout< ContentType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.content.owner = self.owner
        }
    }
    
    public var frame: Rect {
        return self.content.frame
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var content: ContentType {
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
        _ content: ContentType
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
        return self.content.sizeOf(request
            .override(width: request.container.width)
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        return self.content.arrange(request
            .override(width: request.container.width)
        )
    }
    
    public func collect(_ collector: Collector) {
        self.content.collect(collector)
    }
    
}
