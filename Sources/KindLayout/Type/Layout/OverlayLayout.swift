//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class OverlayLayout< ContentType : ILayout, OverlayType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.content.owner = self.owner
            self.overlay.owner = self.owner
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
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var overlay: OverlayType {
        willSet {
            guard self.overlay !== newValue else { return }
            self.overlay.owner = nil
            self.overlay.parent = nil
        }
        didSet {
            guard self.overlay !== oldValue else { return }
            self.overlay.parent = self
            self.overlay.owner = self.owner
            self.update()
        }
    }
    
    public init(
        content: ContentType,
        overlay: OverlayType
    ) {
        self.content = content
        self.overlay = overlay
        
        self.content.parent = self
        self.overlay.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
