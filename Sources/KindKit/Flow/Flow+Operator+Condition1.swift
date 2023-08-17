//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Condition1<
        Input : IFlowResult,
        Output : IFlowResult,
        Pipeline1 : IFlowPipeline
    > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Output
        
        private let _pipeline1: Pipeline1
        private var _subscription1: IFlowSubscription!
        private let _closure: (Result< Input.Success, Input.Failure >) -> State
        private var _state: State?
        private var _next: IFlowPipe!
        
        init(
            _ pipeline1: Pipeline1,
            _ closure: @escaping (Result< Input.Success, Input.Failure >) -> State
        ) {
            self._pipeline1 = pipeline1
            self._closure = closure
            self._subscription1 = pipeline1.subscribe(
                onReceiveValue: { [weak self] in self?._next.send(value: $0) },
                onReceiveError: { [weak self] in self?._next.send(error: $0) },
                onCompleted: { [weak self] in self?._next.completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            let state = self._closure(.success(value))
            self._state = state
            self._handle(state)
        }
        
        public func receive(error: Input.Failure) {
            let state = self._closure(.failure(error))
            self._state = state
            self._handle(state)
        }
        
        public func completed() {
            switch self._state {
            case .some(let value):
                switch value {
                case .next: self._pipeline1.completed()
                case .skip: self._next.completed()
                }
            case .none:
                self._next.completed()
            }
        }
        
        public func cancel() {
            self._pipeline1.cancel()
            self._next.cancel()
        }
        
    }
    
}

public extension Flow.Operator.Condition1 {
    
    enum State {
        
        case next(Result< Pipeline1.Input.Success, Pipeline1.Input.Failure >)
        case skip(Result< Output.Success, Output.Failure >)
        
    }
    
}

private extension Flow.Operator.Condition1 {
    
    func _handle(_ state: State) {
        switch state {
        case .next(let value):
            switch value {
            case .success(let value): self._pipeline1.send(value: value)
            case .failure(let error): self._pipeline1.send(error: error)
            }
        case .skip(let value):
            switch value {
            case .success(let value): self._next.send(value: value)
            case .failure(let error): self._next.send(error: error)
            }
        }
    }
    
}

public extension IFlowBuilder {

    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Bool,
        then: Then
    ) -> Flow.Chain< Head, Flow.Operator.Condition1< Tail.Output, Then.Output, Then > > where
        Tail.Output.Success == Then.Input.Success,
        Tail.Output.Failure == Then.Input.Failure,
        Then.Input == Then.Output
    {
        return self.append(.init(then, { input in
            switch input {
            case .success(let value):
                switch `if`(input) {
                case true: return .next(.success(value))
                case false: return .skip(.success(value))
                }
            case .failure(let error):
                switch `if`(input) {
                case true: return .next(.failure(error))
                case false: return .skip(.failure(error))
                }
            }
        }))
    }
    
    func unwrap<
        Else : IFlowPipeline
    >(
        `else`: Else
    ) -> Flow.Chain< Head, Flow.Operator.Condition1< Tail.Output, Else.Output, Else > > where
        Tail.Output.Success : IOptionalConvertible,
        Tail.Output.Success.Wrapped == Else.Output.Success,
        Tail.Output.Failure == Else.Input.Failure,
        Else.Input.Success == Void
    {
        return self.append(.init(`else`, { input in
            switch input {
            case .success(let value):
                if let value = value.asOptional {
                    return .skip(.success(value))
                } else {
                    return .next(.success(()))
                }
            case .failure(let error):
                return .next(.failure(error))
            }
        }))
    }

}
