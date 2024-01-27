//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class SubstrateLayout< SubstrateType : ILayout, ContentType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.substrate.owner = self.owner
            self.content.owner = self.owner
        }
    }
    
    public var frame: Rect {
        return self.content.frame
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var substrate: SubstrateType {
        willSet {
            guard self.substrate !== newValue else { return }
            self.substrate.owner = nil
            self.substrate.parent = nil
        }
        didSet {
            guard self.substrate !== oldValue else { return }
            self.substrate.parent = self
            self.substrate.owner = self.owner
            self.update()
        }
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
        substrate: SubstrateType,
        content: ContentType
    ) {
        self.substrate = substrate
        self.content = content
        
        self.substrate.parent = self
        self.content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
