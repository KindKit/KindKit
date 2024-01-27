//
//  KindKit
//

import KindDebugger
import KindLog

public final class Fork3Operator< Flow1 : FlowTrait, Flow2 : FlowTrait, Flow3 : FlowTrait > : Operator where Flow1.Input == Flow2.Input, Flow2.Input == Flow3.Input, Flow1.Output.Failure == Flow2.Output.Failure, Flow2.Output.Failure == Flow3.Output.Failure {
    
    public typealias Input = Flow1.Input
    public typealias Output = Result< OutputSuccess, Flow1.Output.Failure >
    public typealias OutputSuccess = (Flow1.Output.Success, Flow2.Output.Success, Flow3.Output.Success)
    
    private let _flow1: Flow1
    private let _flow2: Flow2
    private let _flow3: Flow3
    private var _accumulator1: [Flow1.OutputResult] = []
    private var _accumulator2: [Flow2.OutputResult] = []
    private var _accumulator3: [Flow3.OutputResult] = []
    private var _control1: Control?
    private var _control2: Control?
    private var _control3: Control?
    private var _next: (any Pipe)!
    
    fileprivate init(
        _ flow1: Flow1,
        _ flow2: Flow2,
        _ flow3: Flow3
    ) {
        self._flow1 = flow1
        self._flow2 = flow2
        self._flow3 = flow3
        
        flow1.onReceive(target: self, regular: { $0._receive1($1) })
        flow2.onReceive(target: self, regular: { $0._receive2($1) })
        flow3.onReceive(target: self, regular: { $0._receive3($1) })
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        self._flow1.send(state)
        self._flow2.send(state)
        self._flow3.send(state)
    }
    
}

extension Fork3Operator : @unchecked Sendable {
}

private extension Fork3Operator {
    
    func _receive1(_ state: Flow1.OutputState) {
#if DEBUG
        if self._control1 != nil {
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
            self._accumulator1.append(result)
        case .control(let control):
            self._control1 = control
            self._finishIfPosible()
        }
    }
    
    func _receive2(_ state: Flow2.OutputState) {
#if DEBUG
        if self._control2 != nil {
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
            self._accumulator2.append(result)
        case .control(let control):
            self._control2 = control
            self._finishIfPosible()
        }
    }
    
    func _receive3(_ state: Flow3.OutputState) {
#if DEBUG
        if self._control3 != nil {
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
            self._accumulator3.append(result)
        case .control(let control):
            self._control3 = control
            self._finishIfPosible()
        }
    }
    
    func _finishIfPosible() {
        guard let control1 = self._control1, let control2 = self._control2, let control3 = self._control3 else {
            return
        }
#if DEBUG
        if self._accumulator1.count != self._accumulator2.count || self._accumulator2.count != self._accumulator3.count {
            if isDebuggerPresent() {
                debuggerBreakpoint()
            } else {
                log(plain: .init(
                    level: .debug,
                    object: self,
                    message: "Different amount of data"
                ))
            }
        }
#endif
        let count = min(self._accumulator1.count, self._accumulator2.count, self._accumulator3.count)
        for index in 0 ..< count {
            switch (self._accumulator1[index], self._accumulator2[index], self._accumulator3[index]) {
            case (.success(let result1), .success(let result2), .success(let result3)):
                self._next.send(value: (result1, result2, result3))
            case (.failure(let error), _, _):
                self._next.send(error: error)
            case (_, .failure(let error), _):
                self._next.send(error: error)
            case (_, _, .failure(let error)):
                self._next.send(error: error)
            }
        }
        self._accumulator1.removeAll(keepingCapacity: true)
        self._accumulator2.removeAll(keepingCapacity: true)
        switch (control1, control2, control3) {
        case (.completed, .completed, .completed): self._next.completed()
        case (.canceled, .canceled, .canceled): self._next.cancel()
        default:
            if count > 0 {
                self._next.completed()
            } else {
                self._next.cancel()
            }
        }
    }
    
}

public extension BuilderTrait {
    
    func fork<
        Flow1 : FlowTrait,
        Flow2 : FlowTrait,
        Flow3 : FlowTrait
    >(
        flow1: Flow1,
        flow2: Flow2,
        flow3: Flow3
    ) -> BuilderChain<
        Head,
        Fork3Operator< Flow1, Flow2, Flow3 >
    > where
        Tail.Output == Flow1.Input,
        Tail.Output == Flow2.Input,
        Tail.Output == Flow3.Input,
        Flow1.Output.Failure == Flow2.Output.Failure,
        Flow2.Output.Failure == Flow3.Output.Failure
    {
        return self.append(.init(flow1, flow2, flow3))
    }
    
}
