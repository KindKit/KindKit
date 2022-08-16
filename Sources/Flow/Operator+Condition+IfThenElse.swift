//
//  KindKitFlow
//

import Foundation

public extension Operator.Condition {
    
    final class IfThenElse<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    > : IFlowOperator where
        Then.Input == Else.Input,
        Then.Output == Else.Output
    {
        
        public typealias Input = Then.Input
        public typealias Output = Then.Output
        
        private let _if: (Result< Input.Success, Input.Failure >) -> Bool
        private var _state: Bool?
        private let _then: Then
        private let _else: Else
        private var _thenSubscription: IFlowSubscription!
        private var _elseSubscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ `if`: @escaping (Result< Input.Success, Input.Failure >) -> Bool,
            _ then: Then,
            _ `else`: Else
        ) {
            self._if = `if`
            self._then = then
            self._else = `else`
            self._thenSubscription = then.subscribe(
                onReceiveValue: { [unowned self] in self._receive(value: $0) },
                onReceiveError: { [unowned self] in self._receive(error: $0) },
                onCompleted: { [unowned self] in self._completed() }
            )
            self._elseSubscription = `else`.subscribe(
                onReceiveValue: { [unowned self] in self._receive(value: $0) },
                onReceiveError: { [unowned self] in self._receive(error: $0) },
                onCompleted: { [unowned self] in self._completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            if self._if(.success(value)) == true {
                self._state = true
                self._then.send(value: value)
            } else {
                self._state = false
                self._else.send(value: value)
            }
        }
        
        public func receive(error: Input.Failure) {
            if self._if(.failure(error)) == true {
                self._state = true
                self._then.send(error: error)
            } else {
                self._state = false
                self._else.send(error: error)
            }
        }
        
        public func completed() {
            if self._state == true {
                self._then.completed()
            } else if self._state == false {
                self._else.completed()
            }
        }
        
        public func cancel() {
            self._then.cancel()
            self._else.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension Operator.Condition.IfThenElse {
    
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
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        `if`: @escaping (Result< Then.Input.Success, Then.Input.Failure >) -> Bool,
        then: Then,
        `else`: Else
    ) -> Operator.Condition.IfThenElse< Then, Else > where
        Then.Input == Else.Input,
        Then.Output == Else.Output
    {
        let next = Operator.Condition.IfThenElse< Then, Else >(`if`, then, `else`)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func condition<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        `if`: @escaping (Result< Input.Success, Input.Failure >) -> Bool,
        then: Then,
        `else`: Else
    ) -> Builder.Head< Operator.Condition.IfThenElse< Then, Else > > where
        Input == Then.Input,
        Then.Input == Else.Input,
        Then.Output == Else.Output
    {
        return .init(head: .init(`if`, then, `else`))
    }
    
}

public extension Builder.Head {
    
    func condition<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        `if`: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> Bool,
        then: Then,
        `else`: Else
    ) -> Builder.Chain< Head, Operator.Condition.IfThenElse< Then, Else > > where
        Head.Output == Then.Input,
        Then.Input == Else.Input,
        Then.Output == Else.Output
    {
        return .init(head: self.head, tail: self.head.condition(if: `if`, then: then, else: `else`))
    }
}

public extension Builder.Chain {
    
    func condition<
        Then : IFlowPipeline,
        Else : IFlowPipeline
    >(
        `if`: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> Bool,
        then: Then,
        `else`: Else
    ) -> Builder.Chain< Head, Operator.Condition.IfThenElse< Then, Else > > where
        Head.Output == Then.Input,
        Then.Input == Else.Input,
        Then.Output == Else.Output
    {
        return .init(head: self.head, tail: self.tail.condition(if: `if`, then: then, else: `else`))
    }
    
}
