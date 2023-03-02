//
//  KindKit
//

import Foundation

public extension Flow.Operator.Condition {
    
    final class Unwrap<
        Input : IFlowResult,
        Else : IFlowPipeline
    > : IFlowOperator where
        Input.Success : IOptionalConvertible,
        Else.Input.Success == Void,
        Else.Output.Success == Input.Success.Wrapped,
        Else.Input.Failure == Input.Failure
    {
        
        public typealias Input = Input
        public typealias Output = Else.Output
        
        private var _state: Bool?
        private let _else: Else
        private var _elseSubscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ `else`: Else
        ) {
            self._else = `else`
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
                self._next.send(value: value)
            } else {
                self._state = false
                self._else.send(value: ())
            }
        }
        
        public func receive(error: Input.Failure) {
            switch self._state {
            case .some(let value):
                if value == true {
                    self._next.send(error: error)
                } else {
                    self._else.send(error: error)
                }
            case .none:
                self._next.send(error: error)
            }
        }
        
        public func completed() {
            switch self._state {
            case .some(let value):
                if value == true {
                    self._next.completed()
                } else {
                    self._else.completed()
                }
            case .none:
                self._next.completed()
            }
        }
        
        public func cancel() {
            self._else.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Condition.Unwrap {
    
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
        Else : IFlowPipeline
    >(
        _ `else`: Else
    ) -> Flow.Operator.Condition.Unwrap< Output, Else > where
        Output.Success : IOptionalConvertible,
        Else.Input.Success == Void,
        Else.Output.Success == Output.Success.Wrapped,
        Else.Input.Failure == Output.Failure
    {
        let next = Flow.Operator.Condition.Unwrap< Output, Else >(`else`)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func unwrap<
        Else : IFlowPipeline
    >(
        `else`: Else
    ) -> Flow.Head.Builder< Flow.Operator.Condition.Unwrap< Input, Else > > where
        Input.Success : IOptionalConvertible,
        Else.Input.Success == Void,
        Else.Output.Success == Input.Success.Wrapped,
        Else.Input.Failure == Input.Failure
    {
        return .init(head: .init(`else`))
    }
    
}

public extension Flow.Head.Builder {
    
    func unwrap<
        Else : IFlowPipeline
    >(
        `else`: Else
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Condition.Unwrap< Head.Output, Else > > where
        Head.Output.Success : IOptionalConvertible,
        Else.Input.Success == Void,
        Else.Output.Success == Head.Output.Success.Wrapped,
        Else.Input.Failure == Head.Output.Failure
    {
        return .init(head: self.head, tail: self.head.unwrap(`else`))
    }
}

public extension Flow.Chain.Builder {
    
    func unwrap<
        Else : IFlowPipeline
    >(
        `else`: Else
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Condition.Unwrap< Tail.Output, Else > > where
        Tail.Output.Success : IOptionalConvertible,
        Else.Input.Success == Void,
        Else.Output.Success == Tail.Output.Success.Wrapped,
        Else.Input.Failure == Tail.Output.Failure
    {
        return .init(head: self.head, tail: self.tail.unwrap(`else`))
    }
    
}
