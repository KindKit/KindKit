//
//  KindKit
//

import Dispatch
import KindDebugger
import KindLog
import KindMeasure
import KindTimer

public final class RetryOperator< Flow : FlowTrait > : Operator {
    
    public typealias Input = Flow.Input
    public typealias Output = Flow.Output
    public typealias When = @Sendable (InputResult, OutputState, Time) -> Retry
    
    private let _flow: Flow
    private let _when: When
    private var _item: Item?
    private var _timer: OnceTimer?
    private var _next: (any Pipe)!
    
    init(
        _ flow: Flow,
        _ when: @escaping When
    ) {
        self._flow = flow
        self._when = when
        
        flow.onReceive(target: self, regular: { $0._resolve($1) })
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            if self._item != nil {
#if DEBUG
                if isDebuggerPresent() {
                    debuggerBreakpoint()
                } else {
                    log(plain: .init(
                        level: .debug,
                        object: self,
                        message: "There is already a control state, data race is possible"
                    ))
                }
#endif
            } else {
                self._item = .init(startedAt: .now, input: result)
                self._flow.perform(result)
            }
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                self._flow.cancel()
                self._next.cancel()
            }
        }
    }
    
}

extension RetryOperator : @unchecked Sendable {
}

fileprivate extension RetryOperator {
    
    struct Item {
        
        let startedAt: Time
        let input: InputResult
        var elapsed: Time {
            return .now - self.startedAt
        }
        
    }
    
    func _resolve(_ state: OutputState) {
        if let timer = self._timer {
            timer.cancel()
            self._timer = nil
        }
        guard let item = self._item else {
            return
        }
        switch self._when(item.input, state, item.elapsed) {
        case .retry(let time):
            self._timer = .init(interval: time, queue: .global(qos: .utility))
                .onFinished(
                    target: self,
                    regular: { target in
                        target._timer(finished: state)
                    }
                )
                .start()
        case .done:
            self._next.send(state)
        }
    }
    
    func _timer(finished state: OutputState) {
        self._resolve(state)
    }
    
}

public extension BuilderTrait {
    
    func retry< Flow : FlowTrait >(
        flow: Flow,
        when: @escaping @Sendable (Tail.OutputResult, Flow.OutputState, Time) -> Retry
    ) -> BuilderChain<
        Head,
        RetryOperator< Flow >
    > where
        Tail.Output == Flow.Input
    {
        return self.append(.init(flow, when))
    }
    
}
