//
//  KindKit
//

import KindDebugger
import KindLog

public final class ForkOperator< Flow : FlowTrait > : Operator {
    
    public typealias Input = Flow.Input
    public typealias Output = Result< [Flow.Output.Success], Flow.Output.Failure >
    
    private let _flows: [Flow]
    private var _results: [Flow.OutputResult?]
    private var _controls: [Control?]
    private var _numbderOfExpected: Int
    private var _next: (any Pipe)!
    
    fileprivate init< Flows : Swift.Sequence >(_ flows: Flows) where Flows.Element == Flow {
        self._flows = .init(flows)
        self._results = .init(repeating: nil, count: self._flows.count)
        self._controls = .init(repeating: nil, count: self._flows.count)
        self._numbderOfExpected = self._flows.count
        
        for index in self._flows.indices {
            self._flows[index].onReceive(target: self, regular: { $0._receive(index, $1) })
        }
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        for flow in self._flows {
            flow.send(state)
        }
    }
    
}

extension ForkOperator : @unchecked Sendable {
}

private extension ForkOperator {
    
    func _receive(_ index: Int, _ state: Flow.OutputState) {
#if DEBUG
        if self._controls[index] != nil {
            if isDebuggerPresent() {
                debuggerBreakpoint()
            } else {
                log(plain: .init(
                    level: .debug,
                    object: self,
                    message: "There is already a control state, data race is possible"
                ))
            }
        }
#endif
        switch state {
        case .result(let result):
            self._results[index] = result
        case .control(let control):
            if self._controls[index] == nil {
                self._controls[index] = control
                self._numbderOfExpected = self._controls.kk_count(where: { $0 == nil })
            }
            self._finishIfPosible()
        }
    }
    
    func _finishIfPosible() {
        guard self._numbderOfExpected == 0 else { return }
        let result = self._result()
        self._results.removeAll(keepingCapacity: true)
        self._controls.removeAll(keepingCapacity: true)
        self._numbderOfExpected = self._flows.count
        self._next.send(result)
    }
    
    func _result() -> OutputResult {
        var accumulator: Output.Success = []
        for state in self._results {
            switch state.unsafelyUnwrapped {
            case .success(let value): accumulator.append(value)
            case .failure(let error): return .failure(error)
            }
        }
        return .success(accumulator)
    }
    
}

public extension BuilderTrait {
    
    func fork< Flows : Sequence >(
        _ flows: Flows
    ) -> BuilderChain<
        Head,
        ForkOperator< Flows.Element >
    > where
        Flows.Element : FlowTrait,
        Tail.Output == Flows.Element.Input
    {
        return self.append(.init(flows))
    }
    
}
