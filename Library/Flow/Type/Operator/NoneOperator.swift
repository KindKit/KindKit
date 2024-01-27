//
//  KindKit
//

public final class NoneOperator< Input : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Input
    
    private var _next: (Pipe)!
    
    init() {
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        self._next.send(state)
    }
    
}

extension NoneOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func none() -> BuilderChain<
        Head,
        NoneOperator< Tail.Output >
    > {
        return self.append(.init())
    }
    
}
