//
//  KindKit
//

public final class RunOperator< Flow : FlowTrait > : Operator {
    
    public typealias Input = Flow.Input
    public typealias Output = Flow.Output
    
    private let _flow: Flow
    private var _next: (any Pipe)!
    
    init(
        _ flow: Flow
    ) {
        self._flow = flow
        
        flow.onReceive(target: self, regular: { $0._next.send($1) })
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        self._flow.send(state)
    }
    
}

extension RunOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func run< Flow : FlowTrait >(
        flow: Flow
    ) -> BuilderChain<
        Head,
        RunOperator< Flow >
    > where
        Tail.Output == Flow.Input
    {
        return self.append(.init(flow))
    }
    
}
