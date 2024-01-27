//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class StateLayout< State : Equatable & Hashable > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            for item in self.content.values {
                item.scope = self.scope
            }
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @MonadicField
    public var state: State {
        didSet {
            guard self.state != oldValue else { return }
            self.update()
        }
    }
    
    public private(set) var content: [State : any Layout] = [:]

    public init(_ state: State) {
        self.state = state
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        for item in self.content.values {
            item.invalidate(layout)
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard let content = self.content[self.state] else { return .zero }
        return content.sizeOf(request)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard let content = self.content[self.state] else { return .zero }
        return content.arrange(request)
    }
    
    public func collect(_ collector: Collector) {
        guard let content = self.content[self.state] else { return }
        content.collect(collector)
    }
    
}

public extension StateLayout {
    
    @discardableResult
    func set(state: State, content: (any Layout)?) -> Self {
        if let content = self.content[state] {
            content.scope = nil
            content.parent = nil
        }
        self.content[state] = content
        if let content = content {
            content.parent = self
            content.scope = self.scope
        }
        if self.state == state {
            self.update()
        }
        return self
    }
    
    func set< Item : KindLayout.Item >(state: State, content: Item?) -> Self {
        guard let content = content else {
            return self.set(state: state, content: nil)
        }
        return self.set(state: state, content: ItemLayout(content))
    }
    
    func content(state: State) -> (any Layout)? {
        return self.content[state]
    }
    
    func content< Layout : KindLayout.Layout >(_ type: Layout.Type) -> Layout? {
        switch self.content[state] {
        case let content as Layout: return content
        default: return nil
        }
    }
    
    func reset() {
        self.content = [:]
        self.update()
    }
    
}
