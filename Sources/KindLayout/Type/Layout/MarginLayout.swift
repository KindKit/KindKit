//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class MarginLayout< ContentType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.content.owner = self.owner
        }
    }
    
    public private(set) var frame = Rect.zero
    
    @KindMonadicProperty
    public var inset: Inset = .zero {
        didSet {
            guard self.inset != oldValue else { return }
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
        let contentRequest = request.inset(self.inset)
        let contentSize = self.content.sizeOf(contentRequest)
        guard contentSize.isZero == false else { return .zero }
        return contentSize.inset(-self.inset)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let contentRequest = request.inset(self.inset)
        let contentSize = self.content.sizeOf(contentRequest)
        let size = contentSize.map({
            if $0.isZero == false {
                return $0.inset(-self.inset)
            }
            return .zero
        })
        self.frame = .init(
            origin: request.container.origin,
            size: size
        )
        _ = self.content.arrange(.init(
            container: .init(
                origin: contentRequest.container.origin,
                size: contentSize
            )
        ))
        return size
    }
    
    public func collect(_ collector: Collector) {
        return self.content.collect(collector)
    }
    
}
