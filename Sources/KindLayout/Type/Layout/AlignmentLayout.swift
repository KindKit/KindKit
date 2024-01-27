//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class AlignmentLayout< ContentType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            self.content?.owner = self.owner
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @KindMonadicProperty
    public var horizontal: HAlignment = .left {
        didSet {
            guard self.horizontal != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var vertical: VAlignment = .top {
        didSet {
            guard self.vertical != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var content: ContentType? {
        willSet {
            guard self.content !== newValue else { return }
            if let content = self.content {
                content.parent = nil
                content.owner = nil
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
    
    private let _content = ElementCache()
    
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
        self._content.reset()
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.content {
            self.content?.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content else { return .zero }
        let sizeRequest: SizeRequest
        switch (self.vertical, self.horizontal) {
        case (.top, .left):
            sizeRequest = request
        case (.top, .center), (.top, .right):
            sizeRequest = .init(
                container: request.container,
                available: .init(
                    width: request.available.width.normalized(request.container.width),
                    height: request.available.height
                )
            )
        default:
            sizeRequest = .init(
                container: request.container,
                available: .init(
                    width: request.available.width.normalized(request.container.width),
                    height: request.available.height.normalized(request.container.height)
                )
            )
        }
        let size = self._content.sizeOf(sizeRequest, content: content)
        return size.map({
            .init(
                width: sizeRequest.available.width.normalized($0.width),
                height: sizeRequest.available.height.normalized($0.height)
            )
        })
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        let sizeRequest: SizeRequest
        switch (self.vertical, self.horizontal) {
        case (.top, .left):
            sizeRequest = .init(request)
        case (.top, .center), (.top, .right):
            sizeRequest = .init(
                container: request.container.size,
                available: .init(
                    width: request.available.width.normalized(request.container.width),
                    height: request.available.height
                )
            )
        default:
            sizeRequest = .init(
                container: request.container.size,
                available: .init(
                    width: request.available.width.normalized(request.container.width),
                    height: request.available.height.normalized(request.container.height)
                )
            )
        }
        let size = self._content.sizeOf(sizeRequest, content: content)
        self.frame = .init(
            origin: request.container.origin,
            size: size.map({
                .init(
                    width: sizeRequest.available.width.normalized($0.width),
                    height: sizeRequest.available.height.normalized($0.height)
                )
            })
        )
        switch (self.vertical, self.horizontal) {
        case (.top, .left):
            _ = content.arrange(.init(
                container: .init(topLeft: self.frame.topLeft, size: size)
            ))
        case (.top, .center):
            _ = content.arrange(.init(
                container: .init(top: self.frame.top, size: size)
            ))
        case (.top, .right):
            _ = content.arrange(.init(
                container: .init(topRight: self.frame.topRight, size: size)
            ))
        case (.center, .left):
            _ = content.arrange(.init(
                container: .init(left: self.frame.left, size: size)
            ))
        case (.center, .center):
            _ = content.arrange(.init(
                container: .init(center: self.frame.center, size: size)
            ))
        case (.center, .right):
            _ = content.arrange(.init(
                container: .init(right: self.frame.right, size: size)
            ))
        case (.bottom, .left):
            _ = content.arrange(.init(
                container: .init(bottomLeft: self.frame.bottomLeft, size: size)
            ))
        case (.bottom, .center):
            _ = content.arrange(.init(
                container: .init(bottom: self.frame.bottom, size: size)
            ))
        case (.bottom, .right):
            _ = content.arrange(.init(
                container: .init(bottomRight: self.frame.bottomRight, size: size)
            ))
        }
        return self.frame.size
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        return content.collect(collector)
    }
    
}

public extension AlignmentLayout {
    
    @inlinable
    @discardableResult
    func content< ItemType : IItem >(_ item: ItemType) -> Self where ContentType == ItemLayout< ItemType > {
        self.content = ItemLayout(item)
        return self
    }
    
}
