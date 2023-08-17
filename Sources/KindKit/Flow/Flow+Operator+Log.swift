//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Log<
        Input : IFlowResult
    > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Input
        
        private let _closure: (Result< Input.Success, Input.Failure >) -> ILogMessage?
        private var _next: IFlowPipe!
        
        init(
            _ closure: @escaping (Result< Input.Success, Input.Failure >) -> ILogMessage?
        ) {
            self._closure = closure
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            if let message = self._closure(.success(value)) {
                KindKit.Log.shared.log(message: message)
            }
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            if let message = self._closure(.failure(error)) {
                KindKit.Log.shared.log(message: message)
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

public extension IFlowBuilder {
    
    func log(
        _ closure: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> ILogMessage?
    ) -> Flow.Chain< Head, Flow.Operator.Log< Tail.Output > > {
        return self.append(.init(closure))
    }
    
}
