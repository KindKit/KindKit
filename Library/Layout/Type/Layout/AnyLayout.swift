//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class AnyLayout : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        set { self.content.scope = newValue }
        get { self.content.scope }
    }
    
    public var frame: Rect {
        self.content.frame
    }
    
    @MonadicField
    public var content: any Layout {
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
        _ content: any Layout
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
        return self.content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        return self.content.arrange(request)
    }
    
    public func collect(_ collector: Collector) {
        return self.content.collect(collector)
    }
    
}
