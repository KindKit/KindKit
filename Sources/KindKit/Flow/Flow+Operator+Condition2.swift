//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Condition2< Input : IFlowResult, Output : IFlowResult, Pipeline1 : IFlowPipeline, Pipeline2 : IFlowPipeline > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Output
        
        private let _pipeline1: Pipeline1
        private let _pipeline2: Pipeline2
        private var _subscription1: IFlowSubscription!
        private var _subscription2: IFlowSubscription!
        private let _closure: (Result< Input.Success, Input.Failure >) -> State
        private var _state: State?
        private var _next: IFlowPipe!
        
        init(
            _ pipeline1: Pipeline1,
            _ pipeline2: Pipeline2,
            _ closure: @escaping (Result< Input.Success, Input.Failure >) -> State
        ) {
            self._pipeline1 = pipeline1
            self._pipeline2 = pipeline2
            self._closure = closure
            self._subscription1 = pipeline1.subscribe(
                onReceiveValue: { [weak self] in self?._next.send(value: $0) },
                onReceiveError: { [weak self] in self?._next.send(error: $0) },
                onCompleted: { [weak self] in self?._next.completed() }
            )
            self._subscription2 = pipeline2.subscribe(
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
                case .next1: self._pipeline1.completed()
                case .next2: self._pipeline2.completed()
                }
            case .none:
                self._next.completed()
            }
        }
        
        public func cancel() {
            self._pipeline1.cancel()
            self._pipeline2.cancel()
            self._next.cancel()
        }
        
    }
    
}

public extension Flow.Operator.Condition2 {
    
    enum State {
        
        case next1(Result< Pipeline1.Input.Success, Pipeline1.Input.Failure >)
        case next2(Result< Pipeline2.Input.Success, Pipeline2.Input.Failure >)
        
    }
    
}

private extension Flow.Operator.Condition2 {
    
    func _handle(_ state: State) {
        switch state {
        case .next1(let value):
            switch value {
            case .success(let value): self._pipeline1.send(value: value)
            case .failure(let error): self._pipeline1.send(error: error)
            }
        case .next2(let value):
            switch value {
            case .success(let value): self._pipeline2.send(value: value)
            case .failure(let error): self._pipeline2.send(error: error)
            }
        }
    }
    
}

public extension IFlowBuilder {
    
    func condition<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        `if`: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Bool,
        then: Then,
        `else`: Else
    ) -> Flow.Chain< Head, Flow.Operator.Condition2< Tail.Output, Then.Output, Then, Else > > where
        Tail.Output.Success == Then.Input.Success,
        Tail.Output.Success == Else.Input.Success,
        Tail.Output.Failure == Never,
        Then.Output == Else.Output
    {
        return self.append(.init(then, `else`, { input in
            switch input {
            case .success(let value):
                switch `if`(input) {
                case true: return .next1(.success(value))
                case false: return .next2(.success(value))
                }
            case .failure:
                fatalError()
            }
        }))
    }
    
    func condition<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        `if`: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Bool,
        then: Then,
        `else`: Else
    ) -> Flow.Chain< Head, Flow.Operator.Condition2< Tail.Output, Then.Output, Then, Else > > where
        Tail.Output.Success == Then.Input.Success,
        Tail.Output.Success == Else.Input.Success,
        Tail.Output.Failure == Then.Input.Failure,
        Tail.Output.Failure == Else.Input.Failure,
        Then.Output == Else.Output
    {
        return self.append(.init(then, `else`, { input in
            switch input {
            case .success(let value):
                switch `if`(input) {
                case true: return .next1(.success(value))
                case false: return .next2(.success(value))
                }
            case .failure(let error):
                switch `if`(input) {
                case true: return .next1(.failure(error))
                case false: return .next2(.failure(error))
                }
            }
        }))
    }
    
    func unwrap<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        then: Then,
        `else`: Else
    ) -> Flow.Chain< Head, Flow.Operator.Condition2< Tail.Output, Else.Output, Then, Else > > where
        Tail.Output.Success : IOptionalConvertible,
        Tail.Output.Success.Wrapped == Then.Input.Success,
        Tail.Output.Failure == Then.Input.Failure,
        Tail.Output.Failure == Else.Input.Failure,
        Else.Input.Success == Void,
        Then.Output == Else.Output
    {
        return self.append(.init(then, `else`, { input in
            switch input {
            case .success(let value):
                if let value = value.asOptional {
                    return .next1(.success(value))
                } else {
                    return .next2(.success(()))
                }
            case .failure(let error):
                return .next1(.failure(error))
            }
        }))
    }
    
}
