//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class AnchorLayout< ContentType : ILayout, OverlayType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.content.owner = self.owner
            self.overlay.owner = self.owner
        }
    }
    
    public var frame: Rect {
        let contentFrame = self.content.frame
        if self.overlayIgnoreBounds == true {
            return contentFrame
        }
        let overlayFrame = self.overlay.frame
        return contentFrame.union(overlayFrame)
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
    public var contentAnchor: Anchor = .init(x: .half, y: .half) {
        didSet {
            guard self.contentAnchor != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var contentOffset: Point = .zero {
        didSet {
            guard self.contentOffset != oldValue else { return }
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
    
    @KindMonadicProperty
    public var overlayAnchor: Anchor = .init(x: .half, y: .half) {
        didSet {
            guard self.overlayAnchor != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var overlayOffset: Point = .zero {
        didSet {
            guard self.overlayOffset != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var overlayIgnoreBounds: Bool = true
    
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
        let contentSize = self.content.sizeOf(request)
        if self.overlayIgnoreBounds == true {
            return contentSize
        }
        return Self.size(
            contentAnchor: self.contentAnchor,
            contentOffset: self.contentOffset,
            contentSize: contentSize,
            overlayAnchor: self.overlayAnchor,
            overlayOffset: self.overlayOffset,
            overlaySize: self.overlay.sizeOf(request)
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        _ = self.content.arrange(request)
        let contentRect = self.content.frame
        let overlayRect = Self.overlayRect(
            contentAnchor: self.contentAnchor,
            contentOffset: self.contentOffset,
            contentRect: contentRect,
            overlayAnchor: self.overlayAnchor,
            overlayOffset: self.overlayOffset,
            overlaySize: self.overlay.sizeOf(request)
        )
        _ = self.overlay.arrange(.init(
            container: overlayRect
        ))
        return self.frame.size
    }
    
    public func collect(_ collector: Collector) {
        self.content.collect(collector)
        self.overlay.collect(collector)
    }
    
}

private extension AnchorLayout {
    
    static func size(
        contentAnchor: Anchor,
        contentOffset: Point,
        contentSize: Size,
        overlayAnchor: Anchor,
        overlayOffset: Point,
        overlaySize: Size
    ) -> Size {
        let rect = Self.overlayRect(
            contentAnchor: contentAnchor,
            contentOffset: contentOffset,
            contentRect: .init(size: contentSize),
            overlayAnchor: overlayAnchor,
            overlayOffset: overlayOffset,
            overlaySize: overlaySize
        )
        return rect.size
    }
    
    static func overlayRect(
        contentAnchor: Anchor,
        contentOffset: Point,
        contentRect: Rect,
        overlayAnchor: Anchor,
        overlayOffset: Point,
        overlaySize: Size
    ) -> Rect {
        let contentOrigin = Point(
            x: contentRect.minX.lerp(contentRect.maxX, progress: contentAnchor.x) + contentOffset.x,
            y: contentRect.minY.lerp(contentRect.maxY, progress: contentAnchor.y) + contentOffset.y
        )
        let overlayOrigin = Point(
            x: (overlaySize.width * overlayAnchor.x.value) + overlayOffset.x,
            y: (overlaySize.height * overlayAnchor.y.value) + overlayOffset.y
        )
        return .init(
            x: contentOrigin.x - overlayOrigin.x,
            y: contentOrigin.y - overlayOrigin.y,
            size: overlaySize
        )
    }
    
}
