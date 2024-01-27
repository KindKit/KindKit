//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class MarginLayout< ContentType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            if let content = self.content {
                content.owner = self.owner
            }
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
        let contentRequest = request.inset(self.inset)
        let contentSize = content.sizeOf(contentRequest)
        guard contentSize.isZero == false else { return .zero }
        return contentSize.inset(-self.inset)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        let contentRequest = request.inset(self.inset)
        let contentSize = content.sizeOf(contentRequest)
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
        _ = content.arrange(.init(
            container: .init(
                origin: contentRequest.container.origin,
                size: contentSize
            )
        ))
        return size
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        return content.collect(collector)
    }
    
}

public extension MarginLayout {
    
    @inlinable
    @discardableResult
    func content< ItemType : IItem >(_ item: ItemType) -> Self where ContentType == ItemLayout< ItemType > {
        self.content = ItemLayout(item)
        return self
    }
    
}
