//
//  KindKit
//

public final class SequenceOperator< Flow : FlowTrait > : Operator {
    
    public typealias Input = Flow.Input
    public typealias Output = Result< [Flow.Output.Success], Flow.Output.Failure >
    
    private let _flows: [Flow]
    private var _received: InputResult?
    private var _activeFlow: Int?
    private var _accumulator: [Flow.OutputResult?] = []
    private var _next: (any Pipe)!
    
    init< Flows : Swift.Sequence >(_ flows: Flows) where Flows.Element == Flow {
        self._flows = .init(flows)
        self._accumulator = .init(repeating: nil, count: self._flows.count)
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            self._received = result
        case .control(let control):
            switch control {
            case .completed:
                if self._flows.isEmpty == false {
                    self._start(at: self._flows.startIndex)
                } else {
                    self._next.completed()
                }
            case .canceled:
                self._received = nil
                if let index = self._activeFlow {
                    self._flows[index].onReceive(disconnect: self)
                    self._flows[index].cancel()
                    self._activeFlow = nil
                }
                self._accumulator.kk_clear(nil)
                self._next.cancel()
            }
        }
    }
    
}

extension SequenceOperator : @unchecked Sendable {
}

private extension SequenceOperator {
    
    func _start(at index: Int) {
        if let index = self._activeFlow {
            self._flows[index].onReceive(disconnect: self)
        }
        let flow = self._flows[index]
        self._activeFlow = index
        flow.onReceive(target: self, regular: { $0._receive($1) })
        if let received = self._received {
            flow.send(received)
        }
        flow.completed()
    }
    
    func _receive(_ state: Flow.OutputState) {
        switch state {
        case .result(let result):
            self._accumulator.append(result)
        case .control(let control):
            switch control {
            case .completed:
                if let flowIndex = self._activeFlow {
                    if flowIndex == self._flows.endIndex - 1 {
                        self._received = nil
                        self._activeFlow = nil
                        self._next.send(self._result())
                        self._next.completed()
                    } else {
                        self._start(at: flowIndex + 1)
                    }
                }
            case .canceled:
                break
            }
        }
    }
    
    func _result() -> Result< [Flow.Output.Success], Flow.Output.Failure > {
        var result: [Flow.Output.Success] = []
        defer {
            self._accumulator.kk_clear(nil)
        }
        for item in self._accumulator {
            switch item {
            case .success(let value): result.append(value)
            case .failure(let error): return .failure(error)
            case .none: break
            }
        }
        return .success(result)
    }
    
}

public extension BuilderTrait {
    
    func sequence< Flows : Sequence >(
        _ flows: Flows
    ) -> BuilderChain<
        Head,
        SequenceOperator< Flows.Element >
    > where
        Flows.Element : FlowTrait,
        Tail.Output == Flows.Element.Input
    {
        return self.append(.init(flows))
    }
    
}
