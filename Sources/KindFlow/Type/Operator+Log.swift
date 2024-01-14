//
//  KindKit
//

import KindLog

public extension Operator {
    
    final class Log< Input : IResult > : IOperator {
        
        public typealias Input = Input
        public typealias Output = Input
        
        private let _closure: (Result< Input.Success, Input.Failure >) -> KindLog.IMessage?
        private var _next: IPipe!
        
        init(
            _ closure: @escaping (Result< Input.Success, Input.Failure >) -> KindLog.IMessage?
        ) {
            self._closure = closure
        }
        
        public func subscribe(next: IPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            if let message = self._closure(.success(value)) {
                KindLog.default.log(message: message)
            }
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            if let message = self._closure(.failure(error)) {
                KindLog.default.log(message: message)
            }
            self._next.send(error: error)
        }
        
        public func completed() {
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

public extension IBuilder {
    
    func log(
        _ closure: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> KindLog.IMessage?
    ) -> Chain< Head, Operator.Log< Tail.Output > > {
        return self.append(.init(closure))
    }
    
}
