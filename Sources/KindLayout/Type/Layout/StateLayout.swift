//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class StateLayout< StateType : Equatable & Hashable > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            for item in self.content.values {
                item.owner = self.owner
            }
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @KindMonadicProperty
    public var state: StateType {
        didSet {
            guard self.state != oldValue else { return }
            self.update()
        }
    }
    
    public private(set) var content: [StateType : ILayout] = [:]

    public init(_ state: StateType) {
        self.state = state
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
    func set(state: StateType, content: ILayout?) -> Self {
        if let content = self.content[state] {
            content.owner = nil
            content.parent = nil
        }
        self.content[state] = content
        if let content = content {
            content.parent = self
            content.owner = self.owner
        }
        if self.state == state {
            self.update()
        }
        return self
    }
    
    func set< ItemType : IItem >(state: StateType, content: ItemType?) -> Self {
        guard let content = content else {
            return self.set(state: state, content: nil)
        }
        return self.set(state: state, content: ItemLayout(content))
    }
    
    func content(state: StateType) -> ILayout? {
        return self.content[state]
    }
    
    func content< LayoutType : ILayout >(_ type: LayoutType.Type) -> LayoutType? {
        switch self.content[state] {
        case let content as LayoutType: return content
        default: return nil
        }
    }
    
    func reset() {
        self.content = [:]
        self.update()
    }
    
}
