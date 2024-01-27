//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class SubstrateLayout< SubstrateType : ILayout, ContentType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            self.content?.owner = self.owner
            self.substrate?.owner = self.owner
        }
    }
    
    public var frame: Rect {
        guard let content = self.content else { return .zero }
        return content.frame
    }
    
    @KindMonadicProperty
    public var substrate: SubstrateType? {
        willSet {
            guard self.substrate !== newValue else { return }
            if let substrate = self.substrate {
                substrate.owner = nil
                substrate.parent = nil
            }
        }
        didSet {
            guard self.substrate !== oldValue else { return }
            if let substrate = self.substrate {
                substrate.parent = self
                substrate.owner = self.owner
            }
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
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.content {
            self.content?.invalidate()
        } else if layout === self.substrate {
            self.substrate?.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content else { return .zero }
        return content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        let size = content.arrange(request)
        if let substrate = self.substrate {
            _ = substrate.arrange(.init(
                container: content.frame
            ))
        }
        return size
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        if let substrate = self.substrate {
            substrate.collect(collector)
        }
        content.collect(collector)
    }
    
}

public extension SubstrateLayout {
    
    @inlinable
    @discardableResult
    func substrate< ItemType : IItem >(_ item: ItemType) -> Self where SubstrateType == ItemLayout< ItemType > {
        self.substrate = ItemLayout(item)
        return self
    }
    
    @inlinable
    @discardableResult
    func content< ItemType : IItem >(_ item: ItemType) -> Self where ContentType == ItemLayout< ItemType > {
        self.content = ItemLayout(item)
        return self
    }
    
}
