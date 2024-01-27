//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class VFitLayout< Content : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.content.scope = self.scope
        }
    }
    
    public var frame: Rect {
        return self.content.frame
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var content: Content {
        willSet {
            guard self.content !== newValue else { return }
            self.content.scope = nil
            self.content.parent = nil
        }
        didSet {
            guard self.content !== oldValue else { return }
            self.content.parent = self
            self.content.scope = self.scope
            self.update()
        }
    }
    
    public init(
        _ content: Content
    ) {
        self.content = content
        
        self.content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.content {
            self.content.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.content.sizeOf(request
            .override(height: .infinity)
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        return self.content.arrange(request
            .override(height: .infinity)
        )
    }
    
    public func collect(_ collector: Collector) {
        self.content.collect(collector)
    }
    
}
