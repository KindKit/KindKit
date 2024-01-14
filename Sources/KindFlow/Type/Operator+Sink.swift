//
//  KindKit
//

import Foundation

public extension Operator {
    
    final class Sink< Input : IResult > : IOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Input.Success, Input.Failure >
        
        private let _receive: (Result< Input.Success, Input.Failure >) -> Void
        private let _completed: () -> Void
        private var _next: IPipe!
        
        init(
            _ receive: @escaping (Result< Input.Success, Input.Failure >) -> Void,
            _ completed: @escaping () -> Void
        ) {
            self._receive = receive
            self._completed = completed
        }
        
        public func subscribe(next: IPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._receive(.success(value))
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._receive(.failure(error))
            self._next.send(error: error)
        }
        
        public func completed() {
            self._completed()
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

public extension IBuilder {
    
    func sink(
        onReceive: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Void,
        onCompleted: @escaping () -> Void = {}
    ) -> Chain< Head, Operator.Sink< Tail.Output > > {
        return self.append(.init(onReceive, onCompleted))
    }
    
    @inlinable
    func sink(
        onReceiveValue: @escaping (Tail.Output.Success) -> Void = { _ in },
        onReceiveError: @escaping (Tail.Output.Failure) -> Void = { _ in },
        onCompleted: @escaping () -> Void = {}
    ) -> Chain< Head, Operator.Sink< Tail.Output > > {
        return self.sink(
            onReceive: {
                switch $0 {
                case .success(let value): onReceiveValue(value)
                case .failure(let error): onReceiveError(error)
                }
            },
            onCompleted: onCompleted
        )
    }
    
}
