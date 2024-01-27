//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class ItemLayout< ItemType : IItem > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner?
    
    public private(set) var frame: Rect = .zero {
        didSet {
            guard let content = self.content else { return }
            content.frame = self.frame
        }
    }
    
    @KindMonadicProperty
    public var content: ItemType? {
        didSet {
            if let content = oldValue {
                content.layout = nil
            }
            if let content = self.content {
                content.layout = self
                content.frame = self.frame
            }
            self.invalidate()
            self.update()
        }
    }
    
    private let _content = ElementCache()
    
    public init() {
    }
    
    public convenience init(_ content: ItemType) {
        self.init()
        self.content = content
    }
    
    deinit {
        self.content?.layout = nil
    }
    
    public func invalidate() {
        self._content.reset()
    }
    
    public func invalidate(_ layout: ILayout) {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content else { return .zero }
        guard content.isHidden == false else { return .zero }
        return self._content.sizeOf(request, content: content)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content else { return .zero }
        guard content.isHidden == false else { return .zero }
        let size = self._content.sizeOf(request, content: content)
        self.frame = .init(origin: request.container.origin, size: size)
        return size
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content else { return }
        guard content.isHidden == false else { return }
        collector.push(content)
    }
    
}
