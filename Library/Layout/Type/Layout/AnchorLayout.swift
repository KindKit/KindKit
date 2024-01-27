//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class AnchorLayout< Content : Layout, Overlay : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.content.scope = self.scope
            self.overlay.scope = self.scope
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
    
    @MonadicField
    public var contentAnchor: Anchor2 = .init(x: .half, y: .half) {
        didSet {
            guard self.contentAnchor != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    public var contentOffset: Point = .zero {
        didSet {
            guard self.contentOffset != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var overlay: Overlay {
        willSet {
            guard self.overlay !== newValue else { return }
            self.overlay.scope = nil
            self.overlay.parent = nil
        }
        didSet {
            guard self.overlay !== oldValue else { return }
            self.overlay.parent = self
            self.overlay.scope = self.scope
            self.update()
        }
    }
    
    @MonadicField
    public var overlayAnchor: Anchor2 = .init(x: .half, y: .half) {
        didSet {
            guard self.overlayAnchor != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    public var overlayOffset: Point = .zero {
        didSet {
            guard self.overlayOffset != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    public var overlayIgnoreBounds: Bool = true
    
    public init(
        content: Content,
        overlay: Overlay
    ) {
        self.content = content
        self.overlay = overlay
        
        self.content.parent = self
        self.overlay.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
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
        contentAnchor: Anchor2,
        contentOffset: Point,
        contentSize: Size,
        overlayAnchor: Anchor2,
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
        contentAnchor: Anchor2,
        contentOffset: Point,
        contentRect: Rect,
        overlayAnchor: Anchor2,
        overlayOffset: Point,
        overlaySize: Size
    ) -> Rect {
        let contentOrigin = Point(
            x: contentRect.minX.lerp(contentRect.maxX, by: contentAnchor.x) + contentOffset.x,
            y: contentRect.minY.lerp(contentRect.maxY, by: contentAnchor.y) + contentOffset.y
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
