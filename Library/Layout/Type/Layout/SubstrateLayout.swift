//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class SubstrateLayout< Substrate : Layout, Content : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.substrate.scope = self.scope
            self.content.scope = self.scope
        }
    }
    
    public var frame: Rect {
        return self.content.frame
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var substrate: Substrate {
        willSet {
            guard self.substrate !== newValue else { return }
            self.substrate.scope = nil
            self.substrate.parent = nil
        }
        didSet {
            guard self.substrate !== oldValue else { return }
            self.substrate.parent = self
            self.substrate.scope = self.scope
            self.update()
        }
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
        substrate: Substrate,
        content: Content
    ) {
        self.substrate = substrate
        self.content = content
        
        self.substrate.parent = self
        self.content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.substrate {
            self.substrate.invalidate()
        } else if layout === self.content {
            self.content.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let size = self.content.arrange(request)
        _ = self.substrate.arrange(.init(
            container: self.content.frame
        ))
        return size
    }
    
    public func collect(_ collector: Collector) {
        self.substrate.collect(collector)
        self.content.collect(collector)
    }
    
}
