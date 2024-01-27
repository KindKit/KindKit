//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class AlignmentLayout< Content : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.content.scope = self.scope
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @MonadicField
    public var horizontal: HAlignment = .left {
        didSet {
            guard self.horizontal != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    public var vertical: VAlignment = .top {
        didSet {
            guard self.vertical != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var content: Content {
        willSet {
            guard self.content !== newValue else { return }
            self.content.parent = nil
            self.content.scope = nil
        }
        didSet {
            guard self.content !== oldValue else { return }
            self.content.parent = self
            self.content.scope = self.scope
            self.update()
        }
    }
    
    private let _content = ElementCache()
    
    public init(
        _ content: Content
    ) {
        self.content = content
        
        self.content.parent = self
    }
    
    public func invalidate() {
        self._content.reset()
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.content {
            self.content.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        let sizeRequest: SizeRequest
        switch (self.vertical, self.horizontal) {
        case (.top, .left):
            sizeRequest = request
        case (.top, .center), (.top, .right):
            sizeRequest = .init(
                container: request.container,
                available: .init(
                    width: request.available.width.validated(default: request.container.width),
                    height: request.available.height
                )
            )
        default:
            sizeRequest = .init(
                container: request.container,
                available: request.available.validated(default: request.container)
            )
        }
        let size = self._content.sizeOf(sizeRequest, content: self.content)
        return size.map({
            return sizeRequest.available.validated(default: $0)
        })
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let sizeRequest: SizeRequest
        switch (self.vertical, self.horizontal) {
        case (.top, .left):
            sizeRequest = .init(request)
        case (.top, .center), (.top, .right):
            sizeRequest = .init(
                container: request.container.size,
                available: .init(
                    width: request.available.width.validated(default: request.container.width),
                    height: request.available.height
                )
            )
        default:
            sizeRequest = .init(
                container: request.container.size,
                available: request.available.validated(default: request.container.size)
            )
        }
        let size = self._content.sizeOf(sizeRequest, content: content)
        self.frame = .init(
            origin: request.container.origin,
            size: size.map({
                return sizeRequest.available.validated(default: $0)
            })
        )
        switch (self.vertical, self.horizontal) {
        case (.top, .left):
            _ = self.content.arrange(.init(
                container: .init(topLeft: self.frame.topLeft, size: size)
            ))
        case (.top, .center):
            _ = self.content.arrange(.init(
                container: .init(top: self.frame.top, size: size)
            ))
        case (.top, .right):
            _ = self.content.arrange(.init(
                container: .init(topRight: self.frame.topRight, size: size)
            ))
        case (.center, .left):
            _ = self.content.arrange(.init(
                container: .init(left: self.frame.left, size: size)
            ))
        case (.center, .center):
            _ = self.content.arrange(.init(
                container: .init(center: self.frame.center, size: size)
            ))
        case (.center, .right):
            _ = self.content.arrange(.init(
                container: .init(right: self.frame.right, size: size)
            ))
        case (.bottom, .left):
            _ = self.content.arrange(.init(
                container: .init(bottomLeft: self.frame.bottomLeft, size: size)
            ))
        case (.bottom, .center):
            _ = self.content.arrange(.init(
                container: .init(bottom: self.frame.bottom, size: size)
            ))
        case (.bottom, .right):
            _ = self.content.arrange(.init(
                container: .init(bottomRight: self.frame.bottomRight, size: size)
            ))
        }
        return self.frame.size
    }
    
    public func collect(_ collector: Collector) {
        return self.content.collect(collector)
    }
    
}
