//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class MarginLayout< Content : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.content.scope = self.scope
        }
    }
    
    public private(set) var frame = Rect.zero
    
    @MonadicField
    public var inset: Inset = .zero {
        didSet {
            guard self.inset != oldValue else { return }
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
