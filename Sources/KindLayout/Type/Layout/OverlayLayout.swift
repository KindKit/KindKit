//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class OverlayLayout< ContentType : ILayout, OverlayType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            self.content?.owner = self.owner
            self.overlay?.owner = self.owner
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
    
    @KindMonadicProperty
    public var overlay: OverlayType? {
        willSet {
            guard self.overlay !== newValue else { return }
            if let overlay = self.overlay {
                overlay.owner = nil
                overlay.parent = nil
            }
        }
        didSet {
            guard self.overlay !== oldValue else { return }
            if let overlay = self.overlay {
                overlay.parent = self
                overlay.owner = self.owner
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
        } else if layout === self.overlay {
            self.overlay?.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content else { return .zero }
        return content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        let size = content.arrange(request)
        if let overlay = self.overlay {
            _ = overlay.arrange(.init(
                container: content.frame
            ))
        }
        return size
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        content.collect(collector)
        if let overlay = self.overlay {
            overlay.collect(collector)
        }
    }
    
}

public extension OverlayLayout {
    
    @inlinable
    @discardableResult
    func content< ItemType : IItem >(_ item: ItemType) -> Self where ContentType == ItemLayout< ItemType > {
        self.content = ItemLayout(item)
        return self
    }
    
    @inlinable
    @discardableResult
    func overlay< ItemType : IItem >(_ item: ItemType) -> Self where OverlayType == ItemLayout< ItemType > {
        self.overlay = ItemLayout(item)
        return self
    }
    
}
