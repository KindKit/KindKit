//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VFillLayout< ContentType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            self.content?.owner = self.owner
        }
    }
    
    public var frame: Rect {
        guard let content = self.content else { return .zero }
        return content.frame
    }
    
    @KindMonadicProperty
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
    
    public convenience init(_ content: ContentType) {
        self.init()
        self.content = content
    }
    
    public convenience init< ItemType : IItem >(_ content: ItemType) where ContentType == ItemLayout< ItemType > {
        self.init()
        self.content = ItemLayout(content)
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
        return content.sizeOf(request
            .override(height: request.container.height)
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        return content.arrange(request
            .override(height: request.container.height)
        )
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        content.collect(collector)
    }
    
}

public extension VFillLayout {
    
    @inlinable
    @discardableResult
    func content< ItemType : IItem >(_ item: ItemType) -> Self where ContentType == ItemLayout< ItemType > {
        self.content = ItemLayout(item)
        return self
    }
    
}
