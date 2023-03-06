//
//  KindKit
//

import Foundation

public extension Flow.Operator.Condition {
    
    final class If<
        Then : IFlowPipeline
    > : IFlowOperator where
        Then.Input == Then.Output
    {
        
        public typealias Input = Then.Input
        public typealias Output = Then.Output

        private let _if: (Result< Input.Success, Input.Failure >) -> Bool
        private let _then: Then
        private var _thenSubscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ `if`: @escaping (Result< Input.Success, Input.Failure >) -> Bool,
            _ then: Then
        ) {
            self._if = `if`
            self._then = then
            self._thenSubscription = then.subscribe(
                onReceiveValue: { [weak self] in self?._receive(value: $0) },
                onReceiveError: { [weak self] in self?._receive(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            if self._if(.success(value)) == true {
                self._then.send(value: value)
            } else {
                self._receive(value: value)
            }
        }
        
        public func receive(error: Input.Failure) {
            if self._if(.failure(error)) == true {
                self._then.send(error: error)
            } else {
                self._receive(error: error)
            }
        }
        
        public func completed() {
            self._then.completed()
        }
        
        public func cancel() {
            self._then.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Condition.If {
    
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
    
    func condition<
        Then : IFlowPipeline
    >(
        _ `if`: @escaping (Result< Then.Input.Success, Then.Input.Failure >) -> Bool,
        _ then: Then
    ) -> Flow.Operator.Condition.If< Then > where
        Then.Input == Then.Output
    {
        let next = Flow.Operator.Condition.If< Then >(`if`, then)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Input.Success, Input.Failure >) -> Bool,
        then: Then
    ) -> Flow.Head.Builder< Flow.Operator.Condition.If< Then > > where
        Input == Then.Input,
        Then.Input == Then.Output
    {
        return .init(head: .init(`if`, then))
    }
    
}

public extension Flow.Head.Builder {
    
    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> Bool,
        then: Then
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Condition.If< Then > > where
        Head.Output == Then.Input,
        Then.Input == Then.Output
    {
        return .init(head: self.head, tail: self.head.condition(`if`, then))
    }
}

public extension Flow.Chain.Builder {
    
    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Bool,
        then: Then
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Condition.If< Then > > where
        Tail.Output == Then.Input,
        Then.Input == Then.Output
    {
        return .init(head: self.head, tail: self.tail.condition(`if`, then))
    }
    
}
