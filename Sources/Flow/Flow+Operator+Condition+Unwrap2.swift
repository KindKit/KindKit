//
//  KindKit
//

import Foundation

public extension Flow.Operator.Condition {
    
    final class Unwrap2<
        Input : IFlowResult,
        Then : IFlowPipeline,
        Else : IFlowPipeline
    > : IFlowOperator where
        Input.Success : IOptionalConvertible,
        Then.Input.Success == Input.Success.Wrapped,
        Then.Input.Failure == Input.Failure,
        Else.Input.Success == Void,
        Else.Input.Failure == Input.Failure,
        Then.Output == Else.Output
    {
        
        public typealias Input = Input
        public typealias Output = Then.Output
        
        private var _state: Bool?
        private let _then: Then
        private let _else: Else
        private var _thenSubscription: IFlowSubscription!
        private var _elseSubscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ then: Then,
            _ `else`: Else
        ) {
            self._then = then
            self._else = `else`
            self._thenSubscription = then.subscribe(
                onReceiveValue: { [weak self] in self?._receive(value: $0) },
                onReceiveError: { [weak self] in self?._receive(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
            self._elseSubscription = `else`.subscribe(
                onReceiveValue: { [weak self] in self?._receive(value: $0) },
                onReceiveError: { [weak self] in self?._receive(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            if let value = value.asOptional {
                self._state = true
                self._then.send(value: value)
            } else {
                self._state = false
                self._else.send(value: ())
            }
        }
        
        public func receive(error: Input.Failure) {
            switch self._state {
            case .some(let value):
                if value == true {
                    self._then.send(error: error)
                } else {
                    self._else.send(error: error)
                }
            case .none:
                self._then.send(error: error)
                self._else.send(error: error)
            }
        }
        
        public func completed() {
            switch self._state {
            case .some(let value):
                if value == true {
                    self._then.completed()
                } else {
                    self._else.completed()
                }
            case .none:
                self._completed()
            }
        }
        
        public func cancel() {
            self._then.cancel()
            self._else.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Condition.Unwrap2 {
    
    func _receive(value: Output.Success) {
        self._next.send(value: value)
    }
    
    func _receive(error: Output.Failure) {
        self._next.send(error: error)
    }
    
    func _completed() {
        self._next.completed()
    }
    
}

extension IFlowOperator {
    
    func unwrap<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        _ then: Then,
        _ `else`: Else
    ) -> Flow.Operator.Condition.Unwrap2< Output, Then, Else > where
        Output.Success : IOptionalConvertible,
        Then.Input.Success == Output.Success.Wrapped,
        Then.Input.Failure == Output.Failure,
        Else.Input.Success == Void,
        Else.Input.Failure == Output.Failure,
        Then.Output == Else.Output
    {
        let next = Flow.Operator.Condition.Unwrap2< Output, Then, Else >(then, `else`)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func unwrap<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        then: Then,
        `else`: Else
    ) -> Flow.Head.Builder< Flow.Operator.Condition.Unwrap2< Input, Then, Else > > where
        Input.Success : IOptionalConvertible,
        Then.Input.Success == Input.Success.Wrapped,
        Then.Input.Failure == Input.Failure,
        Else.Input.Success == Void,
        Else.Input.Failure == Input.Failure,
        Then.Output == Else.Output
    {
        return .init(head: .init(then, `else`))
    }
    
}

public extension Flow.Head.Builder {
    
    func unwrap<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        then: Then,
        `else`: Else
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Condition.Unwrap2< Head.Output, Then, Else > > where
        Head.Output.Success : IOptionalConvertible,
        Then.Input.Success == Head.Output.Success.Wrapped,
        Then.Input.Failure == Head.Output.Failure,
        Else.Input.Success == Void,
        Else.Input.Failure == Head.Output.Failure,
        Then.Output == Else.Output
    {
        return .init(head: self.head, tail: self.head.unwrap(then, `else`))
    }
}

public extension Flow.Chain.Builder {
    
    func unwrap<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        then: Then,
        `else`: Else
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Condition.Unwrap2< Tail.Output, Then, Else > > where
        Tail.Output.Success : IOptionalConvertible,
        Then.Input.Success == Tail.Output.Success.Wrapped,
        Then.Input.Failure == Tail.Output.Failure,
        Else.Input.Success == Void,
        Else.Input.Failure == Tail.Output.Failure,
        Then.Output == Else.Output
    {
        return .init(head: self.head, tail: self.tail.unwrap(then, `else`))
    }
    
}
