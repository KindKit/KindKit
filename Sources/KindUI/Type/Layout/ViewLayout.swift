//
//  KindKit
//

import KindLayout
import KindMonadicMacro

@KindMonadic
public final class ViewLayout< ViewType : IView > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        set { self._content.owner = newValue }
        get { self._content.owner }
    }
    
    public var frame: Rect {
        return self._content.frame
    }
    
    @KindMonadicProperty
    public var content: ViewType {
        didSet {
            guard self.content !== oldValue else { return }
            self._content.content = self.content.layout
        }
    }
    
    private let _content: ItemLayout< ViewType.LayoutItemType >
    
    public init(_ content: ViewType) {
        self.content = content
        self._content = .init(content.layout)
        self._content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self._content {
            self._content.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self._content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        return self._content.arrange(request)
    }
    
    public func collect(_ collector: Collector) {
        self._content.collect(collector)
    }
    
}

public extension KindLayout.SequenceBuilder {
    
    static func buildExpression< ViewType : IView >(_ component: ViewType) -> ILayout {
        return ViewLayout(component)
    }
    
}

