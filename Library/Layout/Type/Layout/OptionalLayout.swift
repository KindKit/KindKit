//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class OptionalLayout< Content : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.content?.scope = self.scope
        }
    }
    
    public var frame: Rect {
        guard let content = self.content else { return .zero }
        return content.frame
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var content: Content? {
        willSet {
            guard self.content !== newValue else { return }
            if let content = self.content {
                content.scope = nil
                content.parent = nil
            }
        }
        didSet {
            guard self.content !== oldValue else { return }
            if let content = self.content {
                content.parent = self
                content.scope = self.scope
            }
            self.update()
        }
    }
    
    public init() {
    }
    
    public init(_ content: Content) {
        self.content = content
        
        content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.content {
            self.content?.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content else { return .zero }
        return content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        return content.arrange(request)
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        content.collect(collector)
    }
    
}
