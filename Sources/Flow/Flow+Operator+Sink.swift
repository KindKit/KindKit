//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Sink< Input : IFlowResult > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Input.Success, Input.Failure >
        
        private let _receiveValue: (Input.Success) -> Void
        private let _receiveError: (Input.Failure) -> Void
        private let _completed: () -> Void
        private var _next: IFlowPipe!
        
        init(
            _ receiveValue: @escaping (Input.Success) -> Void,
            _ receiveError: @escaping (Input.Failure) -> Void,
            _ completed: @escaping () -> Void
        ) {
            self._receiveValue = receiveValue
            self._receiveError = receiveError
            self._completed = completed
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._receiveValue(value)
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._receiveError(error)
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

extension IFlowOperator {
    
    func sink(
        onReceiveValue: @escaping (Output.Success) -> Void,
        onReceiveError: @escaping (Output.Failure) -> Void,
        onCompleted: @escaping () -> Void
    ) -> Flow.Operator.Sink< Output > {
        let next = Flow.Operator.Sink< Output >(onReceiveValue, onReceiveError, onCompleted)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func sink(
        onReceiveValue: @escaping (Input.Success) -> Void = { _ in },
        onReceiveError: @escaping (Input.Failure) -> Void = { _ in },
        onCompleted: @escaping () -> Void = {}
    ) -> Flow.Head.Builder< Flow.Operator.Sink< Input > > {
        return .init(head: .init(onReceiveValue, onReceiveError, onCompleted))
    }
    
}

public extension Flow.Head.Builder {
    
    func sink(
        onReceiveValue: @escaping (Head.Output.Success) -> Void = { _ in },
        onReceiveError: @escaping (Head.Output.Failure) -> Void = { _ in },
        onCompleted: @escaping () -> Void = {}
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Sink< Head.Output > > {
        return .init(head: self.head, tail: self.head.sink(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        ))
    }
}

public extension Flow.Chain.Builder {
    
    func sink(
        onReceiveValue: @escaping (Tail.Output.Success) -> Void = { _ in },
        onReceiveError: @escaping (Tail.Output.Failure) -> Void = { _ in },
        onCompleted: @escaping () -> Void = {}
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Sink< Tail.Output > > {
        return .init(head: self.head, tail: self.tail.sink(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        ))
    }
    
}
