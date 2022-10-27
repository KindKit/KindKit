//
//  KindKit
//

import Foundation

public extension FlowOperator.Condition {
    
    final class IfThen<
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

private extension FlowOperator.Condition.IfThen {
    
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
        `if`: @escaping (Result< Then.Input.Success, Then.Input.Failure >) -> Bool,
        then: Then
    ) -> FlowOperator.Condition.IfThen< Then > where
        Then.Input == Then.Output
    {
        let next = FlowOperator.Condition.IfThen< Then >(`if`, then)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Input.Success, Input.Failure >) -> Bool,
        then: Then
    ) -> FlowBuilder.Head< FlowOperator.Condition.IfThen< Then > > where
        Input == Then.Input,
        Then.Input == Then.Output
    {
        return .init(head: .init(`if`, then))
    }
    
}

public extension FlowBuilder.Head {
    
    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> Bool,
        then: Then
    ) -> FlowBuilder.Chain< Head, FlowOperator.Condition.IfThen< Then > > where
        Head.Output == Then.Input,
        Then.Input == Then.Output
    {
        return .init(head: self.head, tail: self.head.condition(if: `if`, then: then))
    }
}

public extension FlowBuilder.Chain {
    
    func condition<
        Then : IFlowPipeline
    >(
        `if`: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Bool,
        then: Then
    ) -> FlowBuilder.Chain< Head, FlowOperator.Condition.IfThen< Then > > where
        Tail.Output == Then.Input,
        Then.Input == Then.Output
    {
        return .init(head: self.head, tail: self.tail.condition(if: `if`, then: then))
    }
    
}
