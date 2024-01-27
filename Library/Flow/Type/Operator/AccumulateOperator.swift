//
//  KindKit
//

import KindCore

public final class AccumulateOperator< Input : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Result< [Input.Success], Input.Failure >
    
    private var _value: Output.Success
    private var _error: Output.Failure?
    private var _next: (any Pipe)!
    
    fileprivate init() {
        self._value = []
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            switch result {
            case .success(let value):
                guard self._error == nil else { return }
                self._value.append(value)
            case .failure(let error):
                self._value.removeAll()
                self._error = error
            }
        case .control(let control):
            switch control {
            case .completed:
                if let error = self._error {
                    self._next.send(error: error)
                    self._error = nil
                } else {
                    self._next.send(value: self._value)
                    self._value.removeAll()
                }
                self._next.completed()
            case .canceled:
                self._value.removeAll()
                self._error = nil
                self._next.cancel()
            }
        }
    }
    
}

extension AccumulateOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func accumulate() -> BuilderChain<
        Head,
        AccumulateOperator< Tail.Output >
    > {
        return self.append(.init())
    }
    
}
