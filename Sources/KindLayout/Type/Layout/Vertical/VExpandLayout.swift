//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VExpandLayout< ContentType : ILayout, DetailType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.content.owner = self.owner
            self.detail.owner = self.owner
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
            self._content.reset()
            self.update()
        }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var detail: DetailType {
        willSet {
            guard self.detail !== newValue else { return }
            self.detail.owner = nil
            self.detail.parent = nil
        }
        didSet {
            guard self.detail !== oldValue else { return }
            self.detail.parent = self
            self.detail.owner = self.owner
            self._detail.reset()
            self.update()
        }
    }
    
    private var _content = ElementCache()
    private var _detail = ElementCache()
    
    public init(
        content: ContentType,
        detail: DetailType
    ) {
        self.content = content
        self.detail = detail
        
        self.content.parent = self
        self.detail.parent = self
    }
    
    public func invalidate() {
        self._content.reset()
        self._detail.reset()
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.content {
            self.content.invalidate()
        } else if layout === self.detail {
            self.detail.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return StackHelper.vSize(
            purpose: request,
            spacing: 0,
            contentCount: 2,
            contentSize: { purpose, index in
                switch index {
                case 0:
                    return self._content.sizeOf(purpose, content: self.content)
                case 1:
                    switch self.state {
                    case .collapsed:
                        return .zero
                    case .expanded:
                        return self._detail.sizeOf(purpose, content: self.detail)
                    }
                default:
                    return .zero
                }
            }
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let frames = StackHelper.vFrames(
            purpose: request,
            spacing: 0,
            alignment: self.alignment,
            contentCount: 2,
            contentSize: { purpose, index in
                switch index {
                case 0:
                    return self._content.sizeOf(purpose, content: self.content)
                case 1:
                    switch self.state {
                    case .collapsed:
                        return .init(width: purpose.container.width, height: 0)
                    case .expanded:
                        return self._detail.sizeOf(purpose, content: self.detail)
                    }
                default:
                    return .zero
                }
            }
        )
        self.frame = frames.final
        _ = self.content.arrange(.init(
            container: frames.content[0]
        ))
        _ = self.detail.arrange(.init(
            container: frames.content[1]
        ))
        return frames.final.size
    }
    
    public func collect(_ collector: Collector) {
        self.content.collect(collector)
        if self.state == .expanded {
            self.detail.collect(collector)
        }
    }
    
}

public extension VExpandLayout {
    
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
