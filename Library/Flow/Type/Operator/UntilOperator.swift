//
//  KindKit
//

import KindCore

public final class UntilOperator< Input : ResultTrait, Flow : FlowTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Result< [Flow.Output.Success], Flow.Output.Failure >
    public typealias Resolver = @Sendable (Result< Input.Success, Input.Failure >, Flow.OutputResult?) -> Resolve
    
    public enum Resolve {
        
        case perform(Flow.InputResult)
        case done
        
    }
    
    private let _resolver: Resolver
    private let _flow: Flow
    private var _input: InputResult?
    private var _queue: [Flow.OutputResult] = []
    private var _next: (any Pipe)!
    
    init(
        _ resolver: @escaping Resolver,
        _ flow: Flow
    ) {
        self._resolver = resolver
        self._flow = flow
        
        flow.onReceive(target: self, regular: { $0._receive($1) })
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            self._input = result
            self._perform()
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                self._input = nil
                self._queue.removeAll(keepingCapacity: true)
                self._flow.cancel()
                self._next.cancel()
            }
        }
    }
    
}

extension UntilOperator : @unchecked Sendable {
}

fileprivate extension UntilOperator {
    
    func _receive(_ state: Flow.OutputState) {
        switch state {
        case .result(let result):
            self._queue.append(result)
            self._perform()
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                self._input = nil
                self._queue.removeAll(keepingCapacity: true)
                self._next.cancel()
            }
        }
    }
    
    func _perform() {
        guard let input = self._input else {
            return
        }
        switch self._resolver(input, self._queue.last) {
        case .perform(let state):
            self._flow.send(state)
            self._flow.completed()
        case .done:
            let value = self._queue
            self._input = nil
            self._queue.removeAll(keepingCapacity: true)
            self._next.send(value: value)
            self._next.completed()
        }
    }
    
}

public extension BuilderTrait {
    
    func run< Flow : FlowTrait >(
        until: @escaping @Sendable (Tail.OutputResult, Flow.OutputResult?) -> UntilOperator< Tail.Output, Flow >.Resolve,
        flow: Flow
    ) -> BuilderChain< Head, UntilOperator< Tail.Output, Flow > > {
        return self.append(.init(until, flow))
    }
    
}
