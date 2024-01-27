//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class OptionalLayout< ContentType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.content?.owner = self.owner
        }
    }
    
    public var frame: Rect {
        guard let content = self.content else { return .zero }
        return content.frame
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var content: ContentType? {
        willSet {
            guard self.content !== newValue else { return }
            if let content = self.content {
                content.owner = nil
                content.parent = nil
            }
        }
        didSet {
            guard self.content !== oldValue else { return }
            if let content = self.content {
                content.parent = self
                content.owner = self.owner
            }
            self.update()
        }
    }
    
    public init() {
    }
    
    public init(_ content: ContentType) {
        self.content = content
        
        content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
