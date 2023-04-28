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
        
        private let _closure: (Result< Input.Success, Input.Failure >) -> KindKit.Log.Message?
        private var _next: IFlowPipe!
        
        init(
            _ closure: @escaping (Result< Input.Success, Input.Failure >) -> KindKit.Log.Message?
        ) {
            self._closure = closure
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            if let message = self._closure(.success(value)) {
                KindKit.Log.shared.log(
                    level: message.level,
                    category: message.category,
                    message: message.message
                )
            }
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            if let message = self._closure(.failure(error)) {
                KindKit.Log.shared.log(
                    level: message.level,
                    category: message.category,
                    message: message.message
                )
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

extension IFlowOperator {
    
    func log(
        _ closure: @escaping (Result< Output.Success, Output.Failure >) -> Optional< Log.Message >
    ) -> Flow.Operator.Log< Output > {
        let next = Flow.Operator.Log< Output >(closure)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func log(
        _ closure: @escaping (Result< Input.Success, Input.Failure >) -> Optional< Log.Message >
    ) -> Flow.Head.Builder< Flow.Operator.Log< Input > > {
        return .init(head: .init(closure))
    }
    
}

public extension Flow.Head.Builder {
    
    func log(
        _ closure: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> Optional< Log.Message >
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Log< Head.Output > > {
        return .init(head: self.head, tail: self.head.log(closure))
    }
}

public extension Flow.Chain.Builder {
    
    func log(
        _ closure: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Optional< Log.Message >
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Log< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.log(closure))
    }
    
}
