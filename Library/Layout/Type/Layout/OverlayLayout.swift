//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class OverlayLayout< Content : Layout, Overlay : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.content.scope = self.scope
            self.overlay.scope = self.scope
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
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var overlay: Overlay {
        willSet {
            guard self.overlay !== newValue else { return }
            self.overlay.scope = nil
            self.overlay.parent = nil
        }
        didSet {
            guard self.overlay !== oldValue else { return }
            self.overlay.parent = self
            self.overlay.scope = self.scope
            self.update()
        }
    }
    
    public init(
        content: Content,
        overlay: Overlay
    ) {
        self.content = content
        self.overlay = overlay
        
        self.content.parent = self
        self.overlay.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.content {
            self.content.invalidate()
        } else if layout === self.overlay {
            self.overlay.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let size = self.content.arrange(request)
        _ = self.overlay.arrange(.init(
            container: self.content.frame
        ))
        return size
    }
    
    public func collect(_ collector: Collector) {
        self.content.collect(collector)
        self.overlay.collect(collector)
    }
    
}
