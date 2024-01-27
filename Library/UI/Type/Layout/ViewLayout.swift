//
//  KindKit
//

import KindLayout
import KindMonadicMacro

@Monadic
public final class ViewLayout< View : IView > : ILayout {
    
    public unowned(unsafe) var parent: (any ILayout)?
    
    public unowned(unsafe) var owner: IOwner? {
        set { self._content.owner = newValue }
        get { self._content.owner }
    }
    
    public var frame: Rect {
        return self._content.frame
    }
    
    @MonadicField
    public var content: View {
        didSet {
            guard self.content !== oldValue else { return }
            self._content.content = self.content.layout
        }
    }
    
    private let _content: ItemLayout< View.LayoutItem >
    
    public init(_ content: View) {
        self.content = content
        self._content = .init(content.layout)
        self._content.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any ILayout) {
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
    
    static func buildExpression< View : IView >(_ component: View) -> some ILayout {
        return ViewLayout(component)
    }
    
}

