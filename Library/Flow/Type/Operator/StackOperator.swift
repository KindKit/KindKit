//
//  KindKit
//

import KindCore

public final class StackOperator< Input : ResultTrait, Flow : FlowTrait > : Operator where Input.Success == Flow.Input.Success, Input.Failure == Flow.Input.Failure {
    
    public typealias Input = Input
    public typealias Output = Result< [Flow.Output.Success], Flow.Output.Failure >
    
    private let _mode: Mode
    private var _queue: [InputResult] = []
    private var _accumulator: [Flow.Output.Success] = []
    private var _error: Flow.Output.Failure?
    private let _flow: Flow
    private var _next: (any Pipe)!
    
    init(
        _ mode: Mode,
        _ flow: Flow
    ) {
        self._mode = mode
        self._flow = flow
        
        flow.onReceive(target: self, regular: { $0._receive($1) })
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            self._queue.append(result)
        case .control(let control):
            switch control {
            case .completed:
                self._tick()
            case .canceled:
                self._flow.cancel()
                self._next.cancel()
            }
        }
    }
    
}

extension StackOperator : @unchecked Sendable {
}

public extension StackOperator {
    
    enum Mode {
        
        case fifo
        case lifo
        
    }
    
}

private extension StackOperator {
    
    func _tick() {
        if self._queue.isEmpty == false {
            self._flow.send(self._item())
            self._flow.completed()
        } else {
            if let error = self._error {
                self._next.send(error: error)
            } else {
                self._next.send(value: self._accumulator)
            }
            self._next.completed()
        }
    }
    
    func _receive(_ state: Flow.OutputState) {
        switch state {
        case .result(let result):
            switch result {
            case .success(let value):
                self._accumulator.append(value)
            case .failure(let error):
                self._queue.removeAll()
                self._accumulator.removeAll()
                self._error = error
            }
        case .control(let control):
            switch control {
            case .completed: self._tick()
            case .canceled: break
            }
        }
    }
    
    func _item() -> Result< Input.Success, Input.Failure > {
        switch self._mode {
        case .fifo: return self._queue.removeFirst()
        case .lifo: return self._queue.removeLast()
        }
    }
    
}

public extension BuilderTrait {
    
    func fifo< Flow : FlowTrait >(
        flow: Flow
    ) -> BuilderChain<
        Head,
        StackOperator< Tail.Output, Flow >
    > where
        Tail.Output.Success == Flow.Input.Success,
        Tail.Output.Failure == Never
    {
        return self.append(.init(.fifo, flow))
    }
    
    func fifo< Flow : FlowTrait >(
        flow: Flow
    ) -> BuilderChain<
        Head,
        StackOperator< Tail.Output, Flow >
    > where
        Tail.Output.Success == Flow.Input.Success,
        Tail.Output.Failure == Flow.Input.Failure
    {
        return self.append(.init(.fifo, flow))
    }
    
    func lifo< Flow : FlowTrait >(
        flow: Flow
    ) -> BuilderChain<
        Head,
        StackOperator< Tail.Output, Flow >
    > where
        Tail.Output.Success == Flow.Input.Success,
        Tail.Output.Failure == Never
    {
        return self.append(.init(.lifo, flow))
    }
    
    func lifo< Flow : FlowTrait >(
        flow: Flow
    ) -> BuilderChain<
        Head,
        StackOperator< Tail.Output, Flow >
    > where
        Tail.Output.Success == Flow.Input.Success,
        Tail.Output.Failure == Flow.Input.Failure
    {
        return self.append(.init(.lifo, flow))
    }
    
}
