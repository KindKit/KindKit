//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class MapError< Input : IFlowResult, Transform : Swift.Error > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Input.Success, Transform >
        
        private let _perform: (Input.Failure) -> Output.Failure
        private var _next: IFlowPipe!
        
        init(
            _ perform: @escaping (Input.Failure) -> Output.Failure
        ) {
            self._perform = perform
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._next.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._next.send(error: self._perform(error))
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
    
    func mapError<
        Transform : Swift.Error
    >(
        _ perform: @escaping (Output.Failure) -> Transform
    ) -> Flow.Operator.MapError< Output, Transform > {
        let next = Flow.Operator.MapError< Output, Transform >(perform)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func mapError<
        Transform : Swift.Error
    >(
        _ perform: @escaping (Input.Failure) -> Transform
    ) -> Flow.Head.Builder< Flow.Operator.MapError< Input, Transform > > {
        return .init(head: .init(perform))
    }
    
}

public extension Flow.Head.Builder {
    
    func mapError<
        Transform : Swift.Error
    >(
        _ perform: @escaping (Head.Output.Failure) -> Transform
    ) -> Flow.Chain.Builder< Head, Flow.Operator.MapError< Head.Output, Transform > > {
        return .init(head: self.head, tail: self.head.mapError(perform))
    }
}

public extension Flow.Chain.Builder {
    
    func mapError<
        Transform : Swift.Error
    >(
        _ perform: @escaping (Tail.Output.Failure) -> Transform
    ) -> Flow.Chain.Builder< Head, Flow.Operator.MapError< Tail.Output, Transform > > {
        return .init(head: self.head, tail: self.tail.mapError(perform))
    }
    
}
