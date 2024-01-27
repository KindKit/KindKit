//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VExpandLayout< ContentType : ILayout, DetailType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            self.content?.owner = self.owner
            self.detail?.owner = self.owner
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @KindMonadicProperty
    public var state: State = .collapsed {
        didSet {
            guard self.state != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var alignment: HAlignment = .left {
        didSet {
            guard self.alignment != oldValue else { return }
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
            self._content.reset()
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var detail: DetailType? {
        willSet {
            guard self.detail !== newValue else { return }
            if let detail = self.detail {
                detail.owner = nil
                detail.parent = nil
            }
        }
        didSet {
            guard self.detail !== oldValue else { return }
            if let detail = self.detail {
                detail.parent = self
                detail.owner = self.owner
            }
            self._detail.reset()
            self.update()
        }
    }
    
    private var _content = ElementCache()
    private var _detail = ElementCache()
    
    public init() {
    }
    
    public func invalidate() {
        self._content.reset()
        self._detail.reset()
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.content {
            self.content?.invalidate()
        } else if layout === self.detail {
            self.detail?.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content else { return .zero }
        return StackHelper.vSize(
            purpose: request,
            spacing: 0,
            contentCount: 2,
            contentSize: { purpose, index in
                switch index {
                case 0:
                    return self._content.sizeOf(purpose, content: content)
                case 1:
                    switch self.state {
                    case .collapsed:
                        return .zero
                    case .expanded:
                        guard let detail = self.detail else { return .zero }
                        return self._detail.sizeOf(purpose, content: detail)
                    }
                default:
                    return .zero
                }
            }
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        let frames = StackHelper.vFrames(
            purpose: request,
            spacing: 0,
            alignment: self.alignment,
            contentCount: 2,
            contentSize: { purpose, index in
                switch index {
                case 0:
                    return self._content.sizeOf(purpose, content: content)
                case 1:
                    switch self.state {
                    case .collapsed:
                        return .init(width: purpose.container.width, height: 0)
                    case .expanded:
                        guard let detail = self.detail else { return .zero }
                        return self._detail.sizeOf(purpose, content: detail)
                    }
                default:
                    return .zero
                }
            }
        )
        self.frame = frames.final
        _ = content.arrange(.init(
            container: frames.content[0]
        ))
        if let detail = self.detail {
            _ = detail.arrange(.init(
                container: frames.content[1]
            ))
        }
        return frames.final.size
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        content.collect(collector)
        if self.state == .expanded {
            if let detail = self.detail {
                detail.collect(collector)
            }
        }
    }
    
}

public extension VExpandLayout {
    
    @inlinable
    @discardableResult
    func content< ItemType : IItem >(_ item: ItemType) -> Self where ContentType == ItemLayout< ItemType > {
        self.content = ItemLayout(item)
        return self
    }
    
    @inlinable
    @discardableResult
    func detail< ItemType : IItem >(_ item: ItemType) -> Self where DetailType == ItemLayout< ItemType > {
        self.detail = ItemLayout(item)
        return self
    }
    
    @inlinable
    @discardableResult
    func toggle() -> Self {
        switch self.state {
        case .collapsed: self.state = .expanded
        case .expanded: self.state = .collapsed
        }
        return self
    }
    
}
